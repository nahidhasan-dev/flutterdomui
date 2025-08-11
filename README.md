# flutter_dom_ui

[![pub package](https://img.shields.io/pub/v/flutter_dom_ui.svg)](https://pub.dev/packages/flutter_dom_ui)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD--3--Clause-blue.svg)](LICENSE)

**flutter_dom_ui** is a Flutter UI utility package designed to improve **SEO-friendliness** and **accessibility** in Flutter web applications. It includes custom semantic widgets like:

`SeoScaffold`, `SeoAppBar`, `SeoBottomNavigationBar`, `SeoCenter`, `SeoContainer`, `SeoFooter`, `SeoListView`,`SeoSingleChildScrollView`, `SeoColumn`, `SeoRow`, `SeoText`, `SeoTextField`, `SeoButton`, `SeoImage`, `SeoLink` — all optimized for **DOM manipulation and web enhancements**.

---

## ✨ Features

- 📦 SEO-friendly widgets (`SeoText`, `SeoImage`, `SeoButton`, etc.)
- ⚡ Custom wrappers for layout widgets: `ListView`,`SingleChildScrollView`, `Column`, `Row`, `Container`, `Center`, `Footer`
- 🔗 Semantic links using `<a>` tag behavior via `SeoLink`
- 🔠 DOM-based text rendering with `SeoText` for better crawlability
- 🧱 Scaffold, BottomNavigationBar and AppBar variants: `SeoScaffold`, `SeoAppBar`, `SeoBottomNavigationBar`
- 🧪 Compatible with **Flutter Web** and supports **unit/widget testing**

---

## 🚀 Getting Started

### 1️⃣ Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_dom_ui: ^<latest_version>
```

Then run:

```bash
flutter pub get
```

### 2️⃣ Import the package

import this package on your dart file:

```dart
import 'package:flutter_dom_ui/flutter_dom_ui.dart';
```

### 💡 Example Usage

```dart
SeoScaffold(
        backgroundColor: Colors.grey.shade100,
        metaTitle: 'Flutter Dom Ui',
        appBar: SeoAppBar(
          backgroundColor: Colors.blue,
          title: SeoText(
            'Flutter Dom Ui',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        bottomNavigationBar: SeoBottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
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
```

### 🌐 Live Demo

Try the live example here:

👉 https://flutterdomui.netlify.app/

### 📸 Screenshot

![Demo of flutter_dom_ui](https://flutterdomui.netlify.app/assets/screenshot.png)

### 📜 License

This package is distributed under the BSD 3-Clause License.

### 🤝 Contributing

Contributions, issues and feature requests are welcome!
Please open an issue or pull request on the GitHub repository.
