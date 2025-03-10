import 'package:flutter/material.dart';
import 'base_info_screen.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseInfoScreen(
      title: '用户协议',
      children: [
        InfoSection(
          title: '协议概述',
          children: [
            InfoParagraph(
              '欢迎使用群英谜阵游戏。本协议是您与我们之间关于使用本应用服务所订立的协议。使用本应用即表示您同意接受本协议的所有条款和条件。',
            ),
          ],
        ),
        InfoSection(
          title: '服务内容',
          children: [
            InfoParagraph(
              '本应用为用户提供群英谜阵游戏服务，包括但不限于：游戏体验、成就系统、数据统计等功能。',
            ),
            InfoParagraph(
              '我们保留在任何时候修改或中断服务而不需通知用户的权利。',
            ),
          ],
        ),
        InfoSection(
          title: '用户行为规范',
          children: [
            InfoParagraph(
              '用户在使用本应用时应遵守中华人民共和国相关法律法规，不得利用本应用进行任何违法或不正当的活动，包括但不限于：',
            ),
            InfoParagraph(
              '1. 发布、传播违法信息',
            ),
            InfoParagraph(
              '2. 干扰应用的正常运行',
            ),
            InfoParagraph(
              '3. 未经授权访问应用系统',
            ),
          ],
        ),
        InfoSection(
          title: '知识产权',
          children: [
            InfoParagraph(
              '本应用的所有内容，包括但不限于文字、图片、音频、视频、软件、程序、代码等，均受知识产权法律法规和相关国际条约保护。',
            ),
            InfoParagraph(
              '未经权利人明确书面授权，任何单位或个人不得以任何方式复制、修改、传播或使用上述内容。',
            ),
          ],
        ),
        InfoSection(
          title: '免责声明',
          children: [
            InfoParagraph(
              '1. 本应用不承诺服务一定能满足用户的所有要求，也不承诺服务不会中断。',
            ),
            InfoParagraph(
              '2. 对于因不可抗力或本应用不能控制的原因造成的服务中断或其他缺陷，本应用不承担任何责任。',
            ),
          ],
        ),
        InfoSection(
          title: '协议修改',
          children: [
            InfoParagraph(
              '我们保留在必要时修改本协议的权利。对本协议的修改将通过在应用内发布的方式公布。',
            ),
            InfoParagraph(
              '如果您不同意修改后的协议，您有权停止使用本应用。如果您继续使用本应用，则视为您接受修改后的协议。',
            ),
          ],
        ),
      ],
    );
  }
}
