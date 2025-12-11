# blog_beispiel

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Appwrite über httpie ansprechen

### Variablen setzen:
  $appwriteProject = 'X-Appwrite-Project:6568509f75ac404ff6ae'
  $appwriteKey = 'X-Appwrite-Key:ac0f362d0cf82fe3d138195e142c0a87a88cee4e2c48821192fb307e1a1c74ee694246f90082b4441aa98a2edaddead28ed6d18cf08c4de0df90dcaeeb53d14f14fb9eeb2edec6708c9553434f1d8df8f8acbfbefd35cccb70f2ab0f9a334dfd979b6052f6e8b8610d57465cbe8d71a7f65e8d48aede789eef6b976b1fe9b2e2'

### Alle Blogs abfragen:
  http -v "https://cloud.appwrite.io/v1/databases/blog-db/collections/blogs/documents" $appwriteProject $appwriteKey

### Nur ein Blog abfragen:
  http -v "https://cloud.appwrite.io/v1/databases/blog-db/collections/blogs/documents/69397a018c57b1ee5e29" $appwriteProject $appwriteKey