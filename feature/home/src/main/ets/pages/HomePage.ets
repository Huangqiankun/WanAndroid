import { HMRouter } from "@hadss/hmrouter";

@HMRouter({ pageUrl: 'Home/HomePage' })
@ComponentV2
export struct HomePage {
  @Local message: string = 'HomePage';

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
