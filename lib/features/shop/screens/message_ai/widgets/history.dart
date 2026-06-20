import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/features/shop/screens/message_ai/message.dart';
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const UAppBar(
        title: Text(
          "LỊCH SỬ TRÒ CHUYỆN",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        showBackArrow: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .orderBy('lastTimestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có lịch sử trò chuyện nào.",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            );
          }
          final chatDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemBuilder: (context, index) {
              final chatData = chatDocs[index].data() as Map<String, dynamic>;
              final lastMsg = chatData['lastMessage'] ?? 'Không có nội dung';
              final lastTime = (chatData['lastTimestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
              final formattedTime = DateFormat('dd/MM/yyyy HH:mm').format(lastTime);
              return Card(
                color: Colors.grey.shade50,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_rounded, color: Colors.blue, size: 24),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "AI Chat Assistant",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
                  onTap: () {
                    Get.to(() => const MessageScreen());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
