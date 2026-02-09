import { HMRouter } from "@hadss/hmrouter";
import { FeatureHomePath } from "common";

@HMRouter({ pageUrl: FeatureHomePath.HOME })
@ComponentV2
export struct HomePage {
  @Local message: string = 'This is HomePage';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
