import { HMRouter } from "@hadss/hmrouter"

@HMRouter({ pageUrl: 'PagePhoneLoading' })
@Component
@Preview
export struct PhoneLoadingPage {
  build() {
    RelativeContainer() {
      Image($r('app.media.phone_loading')).width('100%').height('100%').onClick(()=>{

      })
    }
    .height('100%')
    .width('100%')
  }
}