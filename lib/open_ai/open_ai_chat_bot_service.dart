import 'package:dart_openai/dart_openai.dart';
import '../env/env.dart';

class OpenAIChatBotService {
  Future<String> createModel(String sendMessage) async {
    OpenAI.apiKey = Env.apiKey;
    OpenAI.requestsTimeOut = const Duration(seconds: 60); // 시간 제한 늘림

    // Assistant에게 대화의 방향성을 알려주는 메시지
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "친절하고 애인같은 심리 상담가가 되어줘. 말투는 부드럽고 상냥하게 질문하고 위로해주는 말을 해줘. 처음에는 하루 수면 데이터에 대한 코멘트를 달아주고, 그 다음에는 질문 형식으로 사용자에게 대화를 이끌어 갈 수 있게 해줘. 두 문장으로 대답해줘.",
        ),
      ],
      role: OpenAIChatMessageRole.system,
    );

    // 사용자가 보내는 메시지
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          sendMessage,
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    // OpenAIChatCompletionModel chatCompletion =
    // await OpenAI.instance.chat.create(
    //   // model: 'gpt-3.5-turbo-0125',
    //   model: 'ft:gpt-3.5-turbo-0125:ces-capstone::9PACLx2g',
    //   messages: requestMessages,
    //   maxTokens: 300,
    // );
    //
    // String message =
    // chatCompletion.choices.first.message.content![0].text.toString();
    // return message;
    return "hi";
  }
}