import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/flutter_dom_ui.dart';

void main() {
  runApp(SeoInitializer(child: MainApp()));
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SeoScaffold(
        backgroundColor: Colors.grey.shade100,
        metaTitle: 'Flutter Dom Ui',
        appBar: SeoAppBar(
          backgroundColor: Colors.blue,
          title: SeoText(
            'Flutter Dom Ui',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SeoCenter(
          child: SeoContainer(
            width: 600,
            child: SeoListView(
              children: [
                SeoContainer(
                  margin: EdgeInsets.all(10),
                  width: 600,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: SeoCenter(
                    child: SeoTextField(
                      controller: searchController,
                      placeholder: 'search...',
                      type:
                          InputType
                              .text, // if you add keyboardType then don't need it
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                SeoContainer(
                  margin: EdgeInsets.all(10),
                  width: 600,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: SeoRow(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SeoImage(
                        src:
                            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg',
                        alt: 'Profile Picture',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      SeoColumn(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SeoText(
                            'Md. Nahid Hasan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SeoText(
                            'Founder of crealick.com',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      SeoColumn(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SeoButton(
                            label: 'Add Friend',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.blue,
                              ),
                            ),
                          ),
                          SeoLink(
                            href: 'https://google.com',
                            text: 'search gogle',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SeoContainer(
                  margin: EdgeInsets.all(10),
                  width: 600,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: SeoRow(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SeoImage(
                        src:
                            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg',
                        alt: 'Profile Picture',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      SeoColumn(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SeoText(
                            'Md. Nahid Hasan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SeoText(
                            'Founder of crealick.com',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      SeoColumn(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SeoButton(
                            label: 'Add Friend',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.blue,
                              ),
                            ),
                          ),
                          SeoLink(
                            href: 'https://google.com',
                            text: 'search gogle',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
