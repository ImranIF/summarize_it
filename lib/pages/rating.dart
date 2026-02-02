import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:summarize_it/models/usermodel.dart';
import 'package:summarize_it/provider/userprovider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRating extends StatefulWidget {
  const AppRating({super.key});

  @override
  State<AppRating> createState() => _AppRatingState();
}

class _AppRatingState extends State<AppRating> {
  bool isLoading = false;
  late final UserModel? userModel =
      Provider.of<UserProvider>(context, listen: false).userModel;

  double rating = 0.0;
  double combinedRating = 0.0;

  @override
  void initState() {
    super.initState();
    getRating();
    getCombinedRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 162, 236, 169),
              Color.fromARGB(255, 92, 175, 170),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SafeArea(
                maintainBottomViewPadding: true,
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rating: $rating",
                      style: GoogleFonts.cormorantSc()
                          .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    RatingBar.builder(
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: Colors.amber),
                        minRating: 1,
                        initialRating: rating,
                        itemSize: 32,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        updateOnDrag: true,
                        onRatingUpdate: (rating) {
                          setState(() {
                            this.rating = rating;
                          });
                        }),
                    const SizedBox(height: 15),
                    Material(
                      borderRadius: BorderRadius.circular(24.0),
                      child: InkWell(
                        onTap: () {
                          postRating();
                        },
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Ink(
                            padding: const EdgeInsets.only(
                                top: 12.0,
                                bottom: 12.0,
                                left: 18.0,
                                right: 18.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 111, 199, 158),
                                    Color.fromARGB(255, 101, 182, 144),
                                    // Colors.lightBlueAccent[500]!,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Submitting',
                                        style: GoogleFonts.georama().copyWith(
                                          letterSpacing: 1.5,
                                          color: const Color.fromARGB(
                                              255, 100, 52, 34),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          strokeWidth: 4,
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Submit',
                                        style: GoogleFonts.georama().copyWith(
                                          letterSpacing: 1.5,
                                          color: const Color.fromARGB(
                                              255, 100, 52, 34),
                                        ),
                                      ),
                                    ],
                                  )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // App rating
                    Text(
                        "App Rating: ${double.parse(combinedRating.toStringAsExponential(2))} / 5.0",
                        style: GoogleFonts.cormorantSc().copyWith(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                  ],
                ))))));
  }

  Future<void> getCombinedRating() async {
    try {
      final response = await Supabase.instance.client
          .from('ratings')
          .select('rating');

      if (response.isNotEmpty) {
        double total = 0.0;
        for (var rating in response) {
          total += (rating['rating'] as num).toDouble();
        }
        setState(() {
          combinedRating = total / response.length;
        });
      } else {
        setState(() {
          combinedRating = 0.0;
        });
      }
      print('combinedRating: $combinedRating');
    } catch (e) {
      print('Error getting combined rating: $e');
    }
  }

  Future<void> postRating() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final existingRating = await Supabase.instance.client
          .from('ratings')
          .select()
          .eq('userName', userModel!.userName)
          .maybeSingle();

      if (existingRating == null) {
        final currentUser = Supabase.instance.client.auth.currentUser;
        await Supabase.instance.client.from('ratings').insert({
          'rating': rating,
          'userName': userModel!.userName,
          'user_id': currentUser?.id, // Add Supabase user ID
        });
      } else {
        await Supabase.instance.client
            .from('ratings')
            .update({'rating': rating})
            .eq('userName', userModel!.userName);
      }
      
      getCombinedRating();
    } catch (e) {
      print('Error posting rating: $e');
    }
    
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getRating() async {
    try {
      final response = await Supabase.instance.client
          .from('ratings')
          .select()
          .eq('userName', userModel!.userName)
          .maybeSingle();

      if (response != null) {
        setState(() {
          rating = (response['rating'] as num).toDouble();
        });
      }
    } catch (e) {
      print('Error getting user rating: $e');
    }
  }
}
