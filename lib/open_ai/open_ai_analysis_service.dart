import 'package:dart_openai/dart_openai.dart';
import '../env/env.dart';

class OpenAIAnalysisService {
  Future<String> createModel(String sendMessage) async {
    OpenAI.apiKey = Env.apiKey;
    OpenAI.requestsTimeOut = const Duration(seconds: 60); // 시간 제한 늘림

    // Assistant에게 대화의 방향성을 알려주는 메시지
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "일단 첫 문장의 시작은 전체 수면 시간 기준으로 깊은 수면, 얕은 수면, 렘수면의 비율로 수면의 질 분석한 내용으로 대답을 시작하고, 그 날 데이터의 특별한 부분을 추가로 대답해주는 형식이었으면 좋겠어. 수면 데이터 분석 전문가 처럼 말해주는데 친절하고 쉽게 이해할 수 있도록 해줘. 내가 부탁한 것들을 3~4문장으로 요약해서 대답해줘.",
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
    //   model: 'ft:gpt-3.5-turbo-0125:ces-capstone::9P4Tzz1e',
    //   messages: requestMessages,
    //   maxTokens: 300,
    // );
    //
    // String message =
    // chatCompletion.choices.first.message.content![0].text.toString();
    // return message;
    return "hello";
  }
}