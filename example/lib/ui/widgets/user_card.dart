import 'package:example/models/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final User user;
  final Function(User) onDelete;

  const UserCard({required this.user, required this.onDelete, Key? key}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
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
                    widget.onDelete.call(widget.user);
                  },
                ),
              ),
              Row(
                children: [
                  Image.network(
                    widget.user.image!,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    (widget.user.id?.toString() ?? "-") + ". " + (widget.user.name ?? "-"),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.user.company?.title ?? "-"),
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
