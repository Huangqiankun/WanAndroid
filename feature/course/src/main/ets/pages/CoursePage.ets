import { HMRouter } from "@hadss/hmrouter";


@HMRouter({ pageUrl: 'Course/CoursePage' })
@ComponentV2
export struct CoursePage {
  @Local message: string = 'CoursePage';

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
