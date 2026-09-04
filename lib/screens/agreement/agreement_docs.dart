/// 协议文档内容数据（中英双语）。
/// 《用户协议》与《隐私政策》全文以结构化章节保存，由 AgreementDocPage 渲染。
/// 说明：本应用为纯本地工具（主 Manifest 未声明任何权限、无网络权限），
/// 文案据此如实撰写，不夸大也不含糊。
library;

class AgreementSection {
  final String heading;
  final List<String> paragraphs;
  const AgreementSection({required this.heading, required this.paragraphs});
}

/// 根据当前界面语言返回《用户协议》章节
List<AgreementSection> userAgreementSections({required bool zh}) =>
    zh ? _userAgreementZh : _userAgreementEn;

/// 根据当前界面语言返回《隐私政策》章节
List<AgreementSection> privacyPolicySections({required bool zh}) =>
    zh ? _privacyPolicyZh : _privacyPolicyEn;

// ---------------- 《用户协议》 ----------------

const _userAgreementZh = [
  AgreementSection(
    heading: '一、总则',
    paragraphs: [
      '欢迎使用「日常集」（以下简称"本应用"）。在使用本应用前，请您仔细阅读并充分理解本《用户协议》（以下简称"本协议"）。当您点击"同意并继续"按钮，即视为您已阅读、理解并同意本协议的全部内容。',
      '本应用由个人开发者提供，是一款面向个人日常生活的记录与管理工具。',
    ],
  ),
  AgreementSection(
    heading: '二、服务内容',
    paragraphs: [
      '本应用提供记账理财、习惯健康、减脂健身、日程统筹、待买清单、书影音收藏六个功能模块，帮助您记录支出收入、培养习惯、管理体重体脂、安排日程、整理购物清单与收藏书影音。',
      '本应用的全部功能均为本地离线使用，不依赖网络环境。',
    ],
  ),
  AgreementSection(
    heading: '三、账号与数据',
    paragraphs: [
      '本应用无需注册账号，不收集您的手机号码、姓名等身份信息。',
      '您在使用过程中录入的全部数据仅保存在安装本应用的设备本地，不会上传至任何服务器，也不会向任何第三方提供。',
    ],
  ),
  AgreementSection(
    heading: '四、使用规则',
    paragraphs: [
      '您应当遵守法律法规，合法、正当、善意地使用本应用，不得利用本应用从事任何违反法律法规或侵犯他人合法权益的行为。',
      '您对自己录入的内容的真实性、合法性负责。本应用仅提供记录工具，不对您的生活决策提供任何保证。',
    ],
  ),
  AgreementSection(
    heading: '五、数据存储与备份',
    paragraphs: [
      '本应用不联网，数据仅保存在设备本地。卸载应用、清除应用数据、更换设备或系统恢复出厂设置，均可能导致数据无法找回。',
      '请您定期自行备份重要数据。因上述原因造成的数据丢失或损坏，本应用不承担任何责任。',
    ],
  ),
  AgreementSection(
    heading: '六、知识产权',
    paragraphs: [
      '本应用的软件代码、界面设计及相关素材的知识产权归开发者所有。您仅获得在本设备上安装、使用的非独占许可，不得对本应用进行反向工程、破解、二次分发或用于商业用途。',
    ],
  ),
  AgreementSection(
    heading: '七、协议变更与联系我们',
    paragraphs: [
      '我们可能适时更新本协议，更新后的内容将在本页面公布并构成新的协议。若您不同意变更后的内容，请停止使用本应用；继续使用即视为接受更新后的协议。',
      '如您对本协议有任何疑问或建议，可通过应用的分发渠道或发布页面联系我们。',
      '本协议更新日期：2026 年 9 月 4 日。',
    ],
  ),
];

const _userAgreementEn = [
  AgreementSection(
    heading: '1. General',
    paragraphs: [
      'Welcome to 日常集 ("the App"). Please read this User Agreement carefully before using the App. By tapping "Agree & Continue", you acknowledge that you have read, understood and agreed to all of the terms below.',
      'The App is provided by an individual developer as a personal, offline life-organizing tool.',
    ],
  ),
  AgreementSection(
    heading: '2. Services',
    paragraphs: [
      'The App provides six modules — Money & Budgets, Habits & Health, Fitness, Planner, Shopping List, and Media — to help you track income and expenses, build habits, manage weight and body fat, schedule your day, organize purchases and keep a media collection.',
      'All features work fully offline and do not depend on a network connection.',
    ],
  ),
  AgreementSection(
    heading: '3. Account & Data',
    paragraphs: [
      'The App does not require an account and does not collect personal identifiers such as your phone number or name.',
      'All data you enter is stored only on the device where the App is installed. Nothing is uploaded to any server or shared with any third party.',
    ],
  ),
  AgreementSection(
    heading: '4. Rules of Use',
    paragraphs: [
      'You agree to use the App lawfully and in good faith, and not to use it for any activity that violates the law or infringes the rights of others.',
      'You are responsible for the content you enter. The App is a recording tool only and makes no guarantees about your personal decisions.',
    ],
  ),
  AgreementSection(
    heading: '5. Data Storage & Backup',
    paragraphs: [
      'The App does not connect to the network. Data lives only on your device. Uninstalling the App, clearing its data, switching devices, or restoring your device to factory settings may permanently erase your data.',
      'Please back up important data yourself on a regular basis. The developer is not liable for any data loss or damage caused by the reasons above.',
    ],
  ),
  AgreementSection(
    heading: '6. Intellectual Property',
    paragraphs: [
      'The source code, UI design and related assets of the App are owned by the developer. You are granted a non-exclusive, non-transferable license to install and use the App on your device. Reverse engineering, tampering, redistribution, or commercial use of the App is prohibited.',
    ],
  ),
  AgreementSection(
    heading: '7. Changes & Contact',
    paragraphs: [
      'We may update this Agreement from time to time. The updated version will be published on this page and will take effect as the new Agreement. If you do not agree with the changes, please stop using the App; continued use means acceptance of the updated terms.',
      'If you have any questions or suggestions about this Agreement, please contact us through the channel where you obtained the App.',
      'Last updated: September 4, 2026.',
    ],
  ),
];

// ---------------- 《隐私政策》 ----------------

const _privacyPolicyZh = [
  AgreementSection(
    heading: '一、引言',
    paragraphs: [
      '本应用尊重并保护您的个人信息与隐私。本《隐私政策》（以下简称"本政策"）将说明本应用如何收集、使用与存储您的信息。请您在使用本应用前阅读本政策。',
    ],
  ),
  AgreementSection(
    heading: '二、我们收集的信息',
    paragraphs: [
      '本应用为纯本地工具，无需注册账号，不收集您的姓名、手机号码、邮箱、位置、通讯录、相册等任何身份信息或敏感个人信息。',
      '您在功能模块中录入的内容（账目、习惯、体重体脂、日程、购物清单、书影音收藏等）由您主动输入，仅保存在您的设备上。',
    ],
  ),
  AgreementSection(
    heading: '三、信息的存储',
    paragraphs: [
      '本应用不设自有服务器，也没有任何云端数据库。您的全部数据仅存储在设备本地（应用私有存储空间），不会上传至网络，也不会上传到任何云服务。',
      '数据的安全性与设备本身的安全措施相关。建议您为设备设置锁屏密码，并在更换或维修设备前自行备份。',
    ],
  ),
  AgreementSection(
    heading: '四、网络与权限',
    paragraphs: [
      '本应用未申请网络权限，不会在联网状态下运行，也不会在后台访问网络。',
      '本应用不申请位置、相机、麦克风、通讯录、存储等敏感权限，不会读取您设备上的其他信息。',
    ],
  ),
  AgreementSection(
    heading: '五、第三方服务',
    paragraphs: [
      '本应用不含任何第三方统计、广告或推送 SDK，不会向任何第三方共享、出售或转让您的数据。',
    ],
  ),
  AgreementSection(
    heading: '六、数据的删除',
    paragraphs: [
      '您可以随时在本应用内删除某一条记录，也可在系统设置中清除本应用的数据，从而删除全部数据。删除后数据无法恢复，请您谨慎操作。',
    ],
  ),
  AgreementSection(
    heading: '七、未成年人保护',
    paragraphs: [
      '本应用面向一般用户。若您为未成年人，请在监护人指导下使用本应用，并在征得监护人同意后再录入个人信息。',
    ],
  ),
  AgreementSection(
    heading: '八、政策更新与联系我们',
    paragraphs: [
      '我们可能适时更新本政策，更新后的内容将在此页面公布。若您不同意更新后的内容，请停止使用本应用。',
      '如您对本政策有任何疑问或建议，可通过应用的分发渠道或发布页面联系我们。',
      '本政策更新日期：2026 年 9 月 4 日。',
    ],
  ),
];

const _privacyPolicyEn = [
  AgreementSection(
    heading: '1. Introduction',
    paragraphs: [
      'The App respects and protects your privacy. This Privacy Policy explains how the App handles your information. Please read it before using the App.',
    ],
  ),
  AgreementSection(
    heading: '2. Information We Collect',
    paragraphs: [
      'The App is a fully offline tool. It does not require an account and does not collect any personal identifiers or sensitive information, such as your name, phone number, email, location, contacts or photos.',
      'Content you enter in the modules (transactions, habits, weight and body fat, plans, shopping items, media collection, etc.) is provided by you and stored only on your device.',
    ],
  ),
  AgreementSection(
    heading: '3. How Information Is Stored',
    paragraphs: [
      'The App has no servers and no cloud database. All of your data is stored locally on your device (in the App\'s private storage) and is never uploaded to the network or to any cloud service.',
      'The safety of your data relies on the security of your device. Please lock your device with a passcode and back up before replacing or repairing it.',
    ],
  ),
  AgreementSection(
    heading: '4. Network & Permissions',
    paragraphs: [
      'The App does not request the Internet permission. It does not run with network access and never accesses the network in the background.',
      'The App does not request sensitive permissions such as location, camera, microphone, contacts or storage, and does not read other information on your device.',
    ],
  ),
  AgreementSection(
    heading: '5. Third-Party Services',
    paragraphs: [
      'The App contains no third-party analytics, advertising or push SDKs. Your data is never shared with, sold to or transferred to any third party.',
    ],
  ),
  AgreementSection(
    heading: '6. Deleting Your Data',
    paragraphs: [
      'You can delete individual records inside the App at any time, or clear the App\'s data in your system settings to delete everything. Deleted data cannot be recovered, so please act with care.',
    ],
  ),
  AgreementSection(
    heading: '7. Children\'s Privacy',
    paragraphs: [
      'The App is intended for general users. If you are a minor, please use the App under the guidance of a parent or guardian and obtain their consent before entering personal data.',
    ],
  ),
  AgreementSection(
    heading: '8. Policy Updates & Contact',
    paragraphs: [
      'We may update this Policy from time to time. The updated version will be published on this page. If you do not agree with the changes, please stop using the App.',
      'If you have any questions or suggestions about this Policy, please contact us through the channel where you obtained the App.',
      'Last updated: September 4, 2026.',
    ],
  ),
];
