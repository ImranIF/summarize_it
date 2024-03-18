import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:widget_zoom/widget_zoom.dart';

class GraphQL extends StatelessWidget {
  const GraphQL({super.key});

  @override
  Widget build(BuildContext context) {
    const String hasuraAdminSecret =
        '0r71PA70WMiMU4avCTOEGBXIAe6drGVmqGzctkffKAWO3cbqrBAsVq5ihjaaU1y8';
    const String graphQLEndpoint = 'https://summarize-it.hasura.app/v1/graphql';
    final HttpLink httpLink = HttpLink(
      graphQLEndpoint,
      defaultHeaders: {
        'content-type': 'application/json',
        'x-hasura-admin-secret': hasuraAdminSecret,
      },
    ); // point to endpoint of graphql server

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink as Link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 162, 236, 169),
              Color.fromARGB(255, 92, 175, 170),
              // Color.fromARGB(10, 52, 59, 53),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        'All User Info using GraphQL',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantSc().copyWith(
                          decorationStyle: TextDecorationStyle.dashed,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Color.fromARGB(255, 59, 107, 85),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Query(
                        options: QueryOptions(document: gql(r"""
                              query GetUsers {
                                users {
                                  email
                                  password
                                  fullName
                                  imageURL
                                  address
                                  userName
                                  postCount
                                }
                              }
                """)),
                        builder: (
                          QueryResult result, {
                          Future<QueryResult<Object?>> Function(
                                  FetchMoreOptions)?
                              fetchMore,
                          Future<QueryResult<Object?>?> Function()? refetch,
                        }) {
                          if (result.data == null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/Loading-anim.json',
                                  width: 50,
                                  height: 55,
                                  frameRate: const FrameRate(60),
                                  animate: true,
                                ),
                              ],
                            );
                          } else if (result.hasException) {
                            return Text(result.exception.toString());
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: result.data!['users'].length,
                            itemBuilder: (context, index) {
                              final userInfo = result.data!['users'][index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ExpansionTile(
                                  backgroundColor:
                                      Color.fromARGB(255, 140, 204, 185),
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text(
                                    userInfo['userName'],
                                    style: GoogleFonts.cormorantSc().copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: Color.fromARGB(255, 82, 150, 150),
                                    ),
                                  ),
                                  children: [
                                    WidgetZoom(
                                      heroAnimationTag: 'userImage',
                                      zoomWidget: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          userInfo['imageURL'],
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Email: ${userInfo['email']}',
                                        style: GoogleFonts.georama().copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color:
                                              Color.fromARGB(255, 57, 104, 104),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
