// 工程根目录/hvigorfile.ts
import { appTasks } from '@ohos/hvigor-ohos-plugin';
import { appPlugin } from "@hadss/hmrouter-plugin";

export default {
  system: appTasks,
  plugins: [appPlugin({ ignoreModuleNames: [ /** 不需要扫描的模块 **/ ] })]
};