import 'package:example/models/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final User user;
  final Function(User) onDelete;

  const UserCard({
    required this.user,
    required this.onDelete,
    super.key,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    // if (widget.user.image != null) {
    //   precacheImage(
    //     NetworkImage(widget.user.image!),
    //     context,
    //   );
    // }
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
              Row(
                children: [
                  // Image.network(
                  //   widget.user.image!,
                  //   fit: BoxFit.cover,
                  //   width: 50,
                  //   height: 50,
                  // ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      "${widget.user.id?.toString() ?? "-"}.${widget.user.name ?? "-"}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      maxLines: 2,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => widget.onDelete.call(widget.user),
                    icon: const Icon(Icons.delete, size: 28, color: Colors.red),
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
