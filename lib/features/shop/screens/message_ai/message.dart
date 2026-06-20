import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:shop/common/widgets/appbar/appbar.dart';
import 'package:shop/features/shop/screens/message_ai/widgets/history.dart';
import 'package:shop/features/shop/screens/message_ai/widgets/message_model.dart';
import 'package:shop/utils/constants/apis.dart';


class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});
  static final String apiKey = UApiUrls.deepSeek;
  static const String apiUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}
class _MessageScreenState extends State<MessageScreen> with TickerProviderStateMixin{
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<MessageModel> messages =[];
  late AnimationController animationController;
  String shopDataContext = "";
  final String _chatSessionId = DateTime.now().millisecondsSinceEpoch.toString();
  final List<String> _suggestions = [
    "Shop có bán quần áo không?",
    "Có thương hiệu Adidas không shop?",
    "Sản phẩm nào đang được giảm giá?",
    "Cho mình xin danh mục sản phẩm của shop."
  ];
  late Animation<double> animation;

  bool isLoading = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchShopDataFromFirestore();
    animationController = AnimationController(
        vsync: this,duration: Duration(milliseconds: 300))..repeat();

    setState(() {
      messages.add(
        MessageModel(
          content: 'Hello, how can I help you?',
          isBot: true,
          timestamp: DateTime.now(),
          id: generateId(),
      ));
    });
  }
  String generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(10000).toString();
  }

  Future<void> sendMessage() async {
  if(messageController.text.isEmpty){
    return;
  }
  final userMessage = messageController.text.trim();
  messageController.clear();
  final userTimestamp = DateTime.now();
  final userMsgId = generateId();
  setState(() {
    messages.add(
      MessageModel(
        content: userMessage,
        isBot: false,
        timestamp: userTimestamp,
        id: userMsgId,
      ),
    );
    isLoading = true;
  });
  _scrollToBottom();
  // store message to firestore
  await FirebaseFirestore.instance
      .collection('Chats')
      .doc(_chatSessionId)
      .collection('Messages')
      .doc(userMsgId)
      .set({
    'content': userMessage,
    'isBot': false,
    'timestamp': userTimestamp,
  });
  try {
    final response = await callOpenRouteAPI(userMessage);
    final botTimestamp = DateTime.now();
    final botMsgId = generateId();
    setState(() {
      messages.add(
        MessageModel(
          content: response,
          isBot: true,
          timestamp: botTimestamp,
          id: botMsgId,
        ),
      );
      isLoading = false;
    });
    // store message to firestore
    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(_chatSessionId)
        .collection('Messages')
        .doc(botMsgId)
        .set({
      'content': response,
      'isBot': true,
      'timestamp': botTimestamp,
    });

    // update last message
    await FirebaseFirestore.instance.collection('Chats').doc(_chatSessionId).set({
      'lastMessage': response,
      'lastTimestamp': botTimestamp,
      'chatId': _chatSessionId,
    });
  }catch(e){
    setState(() {
      messages.add(MessageModel(
        content: 'Sorry, something went wrong. Please try again later.',
        isBot: true,
        timestamp: DateTime.now(),
        id: generateId(),
      ));
      isLoading = false;
      });
    }
  _scrollToBottom();
  }

  Future<void> _fetchShopDataFromFirestore() async{
    try {
      // products
      final productsSnapshot = await FirebaseFirestore.instance.collection('Products').get();
      String productsText = "--- DANH SÁCH SẢN PHẨM ---\n";
      Set<String> uniqueBrands = {};
      for (var doc in productsSnapshot.docs) {
        final data = doc.data();
        String title = data['title'] ?? 'Sản phẩm không tên';
        String description = data['description'] ?? 'Không có mô tả';
        double price = (data['price'] as num?)?.toDouble() ?? 0.0;
        double salePrice = (data['salePrice'] as num?)?.toDouble() ?? 0.0;
        int stock = (data['stock'] as num?)?.toInt() ?? 0;
        String sku = data['sku'] ?? 'N/A';
        String brandName = 'Không rõ';
        if (data['brand'] != null && data['brand'] is Map) {
          brandName = data['brand']['name'] ?? 'Không rõ';
          if (brandName != 'Không rõ') {
            uniqueBrands.add(brandName);
          }
        }
        productsText += "- Tên sản phẩm: $title\n"
            "  + Mã SKU: $sku\n"
            "  + Thương hiệu: $brandName\n"
            "  + Giá gốc: $price \$\n"
            "  + Giá khuyến mãi: $salePrice \$\n"
            "  + Số lượng còn lại trong kho: $stock chiếc\n"
            "  + Mô tả chi tiết: $description\n\n";
      }
        // brands
      String brandsText = "--- CÁC THƯƠNG HIỆU ĐANG CÓ ---\n";
      if (uniqueBrands.isNotEmpty) {
        for (var brand in uniqueBrands) {
          brandsText += "- Thương hiệu: $brand\n";
        }
      } else {
        brandsText += "- Đang cập nhật thương hiệu.\n";
      }
      // categories
      final categoriesSnapshot = await FirebaseFirestore.instance.collection('Categories').get();
      String categoriesText = "\n--- DANH MỤC NGÀNH HÀNG ---\n";
      for (var doc in categoriesSnapshot.docs) {
        final data = doc.data();
        // SỬA THÀNH CHỮ VIẾT THƯỜNG: name (đúng theo ảnh Firebase của bạn)
        String name = data['name'] ?? 'Không rõ';
        categoriesText += "- Danh mục: $name\n";
      }


      setState(() {
        shopDataContext = "$productsText\n$brandsText$categoriesText";
      });

    } catch (e) {

      shopDataContext = "Không thể kết nối với kho dữ liệu của Shop.";
    }

  }
  Future<String> callOpenRouteAPI(String message) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${MessageScreen.apiKey}',
      'HTTP-Referer': 'https://example.com',
      'X-Title': 'AI CHAT ASSISTANT'
    };
    final systemInstruction = """
Bạn là một Trợ lý ảo AI độc quyền, chuyên nghiệp và lịch sảo của hệ thống cửa hàng mua sắm (Shop). 
Nhiệm vụ tối cao của bạn là hỗ trợ, tư vấn khách hàng về TẤT CẢ các vấn đề liên quan đến Shop dựa trên các kho dữ liệu thực tế được cung cấp dưới đây.

=======================================================
KHO DỮ LIỆU THỰC TẾ 1: DANH SÁCH SẢN PHẨM & KHO HÀNG (FIRESTORE)
$shopDataContext
=======================================================

=======================================================
KHO DỮ LIỆU THỰC TẾ 2: CẨM NANG HƯỚNG DẪN DÙNG APP & CHÍNH SÁCH SHOP
--- QUY TRÌNH MUA SẮM VÀ CÁCH SỬ DỤNG SHOP ---
1. Chọn sản phẩm: Khách hàng duyệt sản phẩm tại màn hình 'Store' hoặc 'He', bấm trực tiếp vào sản phẩm để xem chi tiết thông tin, hình ảnh.
2. Thêm vào giỏ hàng: Chọn kích thước, màu sắc mong muốn (nếu có) và nhấn nút 'Thêm vào giỏ hàng' hoặc nút 'Mua ngay'.
3. Quản lý yêu thích: Người dùng có thể nhấn vào biểu tượng Trái tim trên sản phẩm để lưu tự động vào màn hình 'Wishlist' nhằm dễ dàng tìm kiếm và xem lại sau này.
4. Tiến hành đặt hàng: Vào màn hình 'Giỏ hàng', kiểm tra kỹ thông tin địa chỉ giao hàng, số điện thoại liên lạc của mình và bấm nút 'Tiến hành thanh toán'.

--- CÁC PHƯƠNG THỨC THANH TOÁN ĐANG HỖ TRỢ ---
Shop hiện tại hỗ trợ 3 hình thức thanh toán vô cùng linh hoạt cho khách hàng:
- Cách 1: Thanh toán khi nhận hàng (COD): Nhận hàng tận nơi, kiểm tra sản phẩm chính xác rồi mới trả tiền mặt trực tiếp cho nhân viên giao hàng (Shipper).
- Cách 2: Chuyển khoản ngân hàng (Banking): Thực hiện chuyển khoản nhanh qua ngân hàng của Shop bằng cách Quét mã QR tự động hiển thị ở bước thanh toán cuối cùng.
- Cách 3: Thanh toán điện tử toàn cầu: Hỗ trợ liên kết ví điện tử MoMo hoặc Cổng thanh toán quốc tế Stripe được tích hợp an toàn, bảo mật sẵn ngay trên app.
=======================================================

⚠️ CÁC QUY TẮC PHẢN HỒI BẮT BUỘC (TUÂN THỦ 100%):

1. ĐỐI VỚI CÂU HỎI VỀ SẢN PHẨM/THƯƠNG HIỆU:
   - Chỉ được phép xác nhận và tư vấn những mặt hàng có tên chính xác trong "KHO DỮ LIỆU 1". Hãy dùng giọng điệu niềm nở, giới thiệu chi tiết giá gốc, giá khuyến mãi, số lượng kho (stock) và mô tả (description) để thuyết phục khách mua.
   - Nếu khách hỏi một sản phẩm hoặc thương hiệu KHÔNG CÓ trong danh sách, BẮT BUỘC trả lời: "Dạ hiện tại mặt hàng/thương hiệu này bên Shop em đang tạm hết hàng hoặc chưa cập nhật ạ. Anh/Chị tham khảo các sản phẩm khác đang sẵn có tại Shop nhé!"

2. ĐỐI VỚI CÂU HỎI VỀ CÁCH DÙNG APP VÀ THANH TOÁN:
   - Dựa vào "KHO DỮ LIỆU 2" để giải thích rõ ràng từng bước sử dụng (cách thêm vào giỏ, cách dùng Wishlist, quy trình thanh toán MoMo/Stripe/COD...). Luôn giữ thái độ lễ phép, dùng từ ngữ như "Dạ", "ạ", "cảm ơn anh/chị".

3. ĐỐI VỚI CÂU HỎI NGOÀI LỀ KHÔNG LIÊN QUAN ĐẾN SHOP:
   - Tuyệt đối KHÔNG ĐƯỢC PHÉP TRẢ LỜI các chủ đề như: toán học, lập trình, thời tiết, triết học, kể chuyện, kiến thức phổ thông, danh nhân, chính trị...
   - Khi gặp câu hỏi phạm quy này, bạn phải lập tức từ chối và phát ngôn chính xác câu thoại sau (không thêm bớt): 
     "Xin lỗi, tôi là trợ lý ảo của Shop và chỉ có thể hỗ trợ các vấn đề liên quan đến cửa hàng, sản phẩm hoặc thanh toán. Vui lòng đặt câu hỏi phù hợp!"
""";
  final body = jsonEncode(
      {'model':'deepseek/deepseek-chat-v3-0324',
        'messages': [
          {'role': 'system', 'content': systemInstruction},
          {'role': 'user', 'content': message},

        ],'max_tokens': 2000,
        'temperature': 0.3,
      }
  );
  final response = await http.post(
    Uri.parse(MessageScreen.apiUrl),
    headers: headers,
    body: body,

  );
  if(response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }
  else {
    throw Exception('Failed to call OpenRoute API ${response.statusCode}' );
  }
}
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    if(scrollController.hasClients) {
      scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      );
    }
   });
  }
  void _sendSuggestionMessage(String suggestionText) {
    messageController.text = suggestionText;
    sendMessage();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }
  Widget _buildAvatar(bool isUser){
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: isUser
            ? LinearGradient(colors: [Color(0xFF667EEA),
          Color(0xFF764BA2),
          ])
            : LinearGradient(colors: [Color(0xFF567AEA),Color(0xFF667EEA),]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(isUser ? Icons.person : Icons.chat,
      color:  Colors.white,
          size: 16,),

    );
  }
  Widget _buildDot(int index){
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.3 +
                    (sin(animationController.value * 2 * pi + index * 0.5) *
                        0.3),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          );

        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: UAppBar(
       title: Text("AI ASSISTANT",
         style: Theme.of(context).textTheme.headlineMedium,),
       showBackArrow: true,
       leadingOnPressed: () {
         Get.back();
       },
       action: [
         IconButton(onPressed: ()=> Get.to(()=> HistoryScreen()), icon: Icon(Icons.history_toggle_off_outlined,))
       ],
     ),
    body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16,),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding:  EdgeInsets.symmetric(horizontal: 20),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isLoading) {
                    return Padding(
                      padding:  EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          _buildAvatar(false),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black54,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildDot(0),
                                SizedBox(width: 4),
                                _buildDot(1),
                                SizedBox(width: 4),
                                _buildDot(2),
                              ],
                            ),
                          ),

                        ],
                      ),
                    );
                  }
                  return _buildMessageBubble(messages[index]);
                },
              ),
            ),
            _buildSuggestions(),
            _buildInputArea()
          ],
        )
      ),
    );
  }
  Widget _buildMessageBubble(MessageModel messages) {
    return Padding(padding: EdgeInsets.only(bottom: 16),
    child: Row(
      mainAxisAlignment: messages.isBot
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end ,
      children: [
        if(messages.isBot) ...[_buildAvatar(false)],
        SizedBox(width: 8,),
        Flexible(child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: messages.isBot ? Colors.white : Colors.white70,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: messages.isBot ? Radius.zero : const Radius.circular(16), // Bo góc cho người dùng
              bottomRight: messages.isBot ? const Radius.circular(16) : Radius.zero, // Bo góc cho Bot
            ),
            border: messages.isBot ? null : Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: messages.isBot
                    ? const Color(0xFF667EEA).withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),

              ), // BoxShadow
            ],

          ),
          child: messages.isBot
              ? Text(
            messages.content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,),
          )
              : GptMarkdown(
            messages.content,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        )),
        SizedBox(width: 8,),
        if(!messages.isBot) ...[_buildAvatar(true)],
      ],
    ),
    );
  }
  Widget _buildInputArea() {
    if(isLoading) {
     animationController.repeat();
    }
    else {
      animationController.stop();
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: TextField(
             controller: messageController,
             maxLines: null,
             onSubmitted: (value){
               sendMessage();
             },
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.black,),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
              ),
            ),
           )
          ),
          SizedBox(width: 16,),
          GestureDetector(
            onTap: isLoading ? null : sendMessage,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(isLoading ? Icons.hourglass_empty :
                Icons.send, color: Colors.white, size: 24,),
            ),
          )

        ],
      ),
    );
  }
  Widget _buildSuggestions() {
    // Chỉ hiển thị gợi ý khi mảng tin nhắn chỉ có 1 câu chào mặc định ban đầu của Bot
    if (messages.length > 1 || isLoading) {
      return const SizedBox.shrink(); // Ẩn hoàn toàn khi đã bắt đầu chat
    }

    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                _suggestions[index],
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              onPressed: () {
                // Kích hoạt gửi tin nhắn tự động khi bấm vào ô
                _sendSuggestionMessage(_suggestions[index]);
              },
            ),
          );
        },
      ),
    );
  }

}
