import 'package:example/models/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;
  final Function(User) onDelete;

  const UserCard({required this.user, required this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("object: ${user.name}");
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: InkWell(
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.delete, size: 28, color: Colors.grey),
                  ),
                  onTap: () {
                    onDelete.call(user);
                  },
                ),
              ),
              Row(
                children: [
                  Image.network(
                    user.image!,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    (user.id?.toString() ?? "-") + ". " + (user.name ?? "-"),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(user.company?.title ?? "-"),
                  const SizedBox(height: 10),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
