import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Build method of the MyApp widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    );
  }
}

class Contact {
  final String id;
  final String name;

  // Constructor for the Contact class
  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

// Defines a class ContactBook that extends ValueNotifier<List<Contact>>.
class ContactBook extends ValueNotifier<List<Contact>> {
  // Private constructor for ContactBook that initializes an empty List<Contact>
  ContactBook._sharedInstance() : super([]);

  // Creates a static instance of ContactBook.
  static final ContactBook _shared = ContactBook._sharedInstance();

  // Factory method to create and return the ContactBook instance.
  factory ContactBook() => _shared;

  // Getter method that returns the length of the List<Contact> object.
  int get length => value.length;

  // Adds a new Contact object to the List<Contact> and notifies listeners of the change.
  void add({required Contact contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  // Removes a Contact object from the List<Contact> and notifies listeners of the change.
  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  // Returns the Contact object at the specified index or null if index is out of bounds.
  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),  // Uses the ContactBook value notifier to listen for changes to the list of contacts
        builder: (contact, value, child) {
          final contacts = value;  // Get the list of contacts
          return ListView.builder(
            itemCount: contacts.length,  // Set the number of items in the list to the length of the contacts list
            itemBuilder: (context, index) {
              final contact = contacts[index];  // Get the contact at the current index
              return Dismissible(
                onDismissed: (direction) {
                  ContactBook().remove(contact: contact);  // Remove the contact when it is dismissed
                },
                key: ValueKey(contact.id),  // Set a unique key for the contact, based on its ID
                child: Material(
                  color: Colors.white,
                  elevation: 6.0,
                  child: ListTile(
                    title: Text(contact.name),  // Display the contact's name in the list
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/new-contact');  // Navigate to the new contact page when the FAB is pressed
        },
        child: const Icon(Icons.add),  // Display an "add" icon on the FAB
      ),
    );
  }
}


// A StatefulWidget that allows adding a new contact
class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

// The state of the NewContactView StatefulWidget
class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  // Initialize _controller
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  // Clean up _controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter a new contact name here...',
            ),
          ),
          TextButton(
              onPressed: () {
                // Create a new contact with the name from the TextField
                final contact = Contact(name: _controller.text);
                // Add the new contact to the ContactBook
                ContactBook().add(contact: contact);
                // Go back to the previous screen
                Navigator.of(context).pop();
              },
              child: const Text('Add Contact'))
        ],
      ),
    );
  }
}

