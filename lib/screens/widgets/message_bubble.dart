import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_to_speech/text_to_speech.dart';

class MessageBubble extends StatelessWidget {
  final dynamic message;
  final String username;
  bool isMe;
  MessageBubble(this.message, this.isMe, this.username);
  TextToSpeech tts = TextToSpeech();

  Widget messageContainer(BuildContext context) {
  final Locale appLocale = Localizations.localeOf(context);
    return Container(
      decoration: BoxDecoration(
        color: isMe ? const Color.fromARGB(255, 0, 166, 36) : Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
            topLeft:
                !isMe ? const Radius.circular(0) : const Radius.circular(20),
            topRight:
                isMe ? const Radius.circular(0) : const Radius.circular(20)),
      ),
      width: (isMe
          ? MediaQuery.of(context).size.width * 0.40
          : MediaQuery.of(context).size.width *
              0.70), //width will not work if we have only container as parent widget
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: message.runtimeType == String
          ? Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.grey[300] : Colors.black,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.grey[300] : Colors.black,
                  ),
                )
              ],
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.grey[300] : Colors.black,
                  ),
                ),
              ),
              message
            ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        //to make width of container work
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // if isMe then show avatar to the right of the container
          if (isMe)
            Row(
              children: [
                IconButton(
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String locale = prefs.getString("locale")!;
                    print(locale);
                    tts.setLanguage(locale);
                    tts.speak(message);
                  },
                  icon: const Icon(Icons.volume_up),
                ),
              ],
            ),
          messageContainer(context),
          if (!isMe)
            Row(
              children: [
                IconButton(
                  onPressed: () async{
                     SharedPreferences prefs = await SharedPreferences.getInstance();
                    String locale = prefs.getString("locale")!;
                    tts.setLanguage(locale);
                    tts.speak(message);
                  },
                  icon: const Icon(Icons.volume_up),
                ),
              ],
            ),
          if (isMe)
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: const NetworkImage('https://picsum.photos/200'),
            ),
        ],
      ),
    );
    // )
  }
}