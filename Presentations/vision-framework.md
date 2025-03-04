<div dir="rtl">

# فریم‌ورک Vision

فریم‌ورک اپل برای انجام الگوریتم‌های بینایی ماشین روی عکس و ویدیو

قابلیت‌های کلی این فریم‌ورک:

- شناسایی حرکات و ژست بدن انسان و حیوان
- شناسایی متن
- شناسایی چهره و نقاط مربوط به چهره مثل چشم و دهان
- شناسایی حرکات دست
- محاسبه و نمره‌دهی به عکس‌ها براساس فاکتورهای مشخص

روند کلی به این صورت هست که یه Request آماده می‌کنیم، و اون ریکوئست تحویل فریم‌ورک میشه برای انجام. نتایج ریکوئست بصورت آرایه در اختیار ما قرار می‌گیره و ازش استفاده می‌کنیم. 

ویژن همچنین این قابلیت رو در اختیار می‌ذاره تا با استفاده از Core ML و مدل اختصاصی خودمون، تصاویر رو بررسی کنیم. 

## نحوه کار

برای کار با عکس ثابت، یه هندلر از نوع `VNImageRequestHandler` می‌سازیم، که کارش اینه که ریکوئست‌های مورد نظرمون رو روی عکس ورودی انجام بده. نتیجه هرکدوم از ریکوئست‌ها، تحویل خودشون میشه.

پیشفرض این هست که عکس رو بصورت UpRight در نظر می‌گیره. پس موقعی که ورودی رو پاس می‌دیم، باید Orientation رو هم در نظر داشته باشیم؛ و بهش پاس بدیم.

ورودی‌های مرسوم این هندلر `CGImage` و `CIImage` و `Data` و `URL` فایل روی دیسک هست، که بهمراه همه‌شون می‌تونیم ‍Orientation رو هم پاس بدیم.

```swift
init(cgImage:options:)
init(cgImage:orientation:options:)

init(ciImage:options:)
init(ciImage:orientation:options:)

init(data:options:)
init(data:orientation:options:)

init(url:options:)
init(url:orientation:options:)
```

می‌تونیم یکی یا چندتا ریکوئست آماده کنیم و همه رو برای انجام تحویل هندلر بدیم و ویژن هرکدوم از ریکوئست‌ها رو روی Thread خودش اجرا می‌کنه و نتایج رو هم روی `completionHandler` خود ریکوئست تحویل میده. 

وقتی هندلر و تمام ریکوئست‌های مورد نیاز آماده شد، با استفاده از متد `perform` ریکوئست‌ها برای انجام پاس داده میشن:

```swift
func perform(_ requests: [VNRequest]) throws
```

نکته اینه که این متد Sync هست، و وقتی Return می‌کنه که تمام ریکوئست‌ها کارشون تموم شده باشه. ازونجا که می‌تونه زمان‌بر باشه، این متد نباید روی Main-Queue فراخوانی بشه.

```swift
DispatchQueue.global(qos: .userInitiated).async {
    do {
        try imageRequestHandler.perform(requests)
    } catch {
        // handle error
    }
}
```

نتیجه درخواست‌ها از دو طریق بعد از فراخوانی `perform(:_)` در دسترس قرار می‌گیره. 
- از طریق `completionHandler` که موقع ساخت Request پاس دادیم.
- از طریق پراپرتی `results` خود ریکوئست‌ها

### بهینه‌سازی

مستندات اپل پیشنهاد میدن که:
- اگه قرار هست چندتا ریکوئست روی یه عکس انجام بشه، همه‌شون بصورت آرایه و با استفاده از یه هندلر انجام بشن؛ و برای هرکدوم، یه هندلر جدا ساخته نشه.
- اگه قرار هست یه سری ریکوئست روی عکس‌های مختلف انجام بشه، برای هرکدوم یه هندلر جدا ساخته بشه، و هرکدوم روی Queueهای مختلف انجام بشن؛ تا بصورت موازی پیش برن.

## کلاس پایه `VNRequest`

این کلاس بعنوان کلاس پایه برای تمام ریکوئست‌ها مورد استفاده قرار می‌گیره.

پراپرتی‌ها و متدهای مهم این کلاس بصورت زیر هست:

- پراپرتی `results`: نتیجه ریکوئست با استفاده از این پراپرتی در دسترس خواهد بود.
- پراپرتی `revision`: این پراپرتی از نوع `Int` هست و مقدارش، الگوریتم یا پیاده‌سازی مورد نظر برای انجام ریکوئست رو مشخص می‌کنه. هرکدوم از انواع ریکوئست‌ها، مقادیر مختلفی رو برای استفاده در نظر گرفتن.
- متد `cancel`: ازین متد برای کنسل‌کردن روند ریکوئست استفاده میشه.

در حال حاضر تنها کلاسی که این کلاس پایه رو Inherit کرده، کلاس `VNImageBasedRequest` هست و پراپرتی زیر رو بهش اضافه کرده:

- پراپرتی `regionOfInterest`: با استفاده از این پراپرتی می‌تونیم مشخص کنیم ریکوئست مورد نظر روی چه قسمتی از عکس ورودی انجام بشه.

کلاس بقیه ریکوئست‌های مربوط به عکس، این کلاس رو Inherit می‌کنن و هرکدوم براساس نیاز خودشون، پراپرتی‌های خودشون رو اضافه می‌کنن.

## کلاس پایه `VNObservation`

تمام ریکوئست‌ها نتیجه خودشون رو بصورت `[VNObservation]` برمی‌گردونن. هر کلاس ریکوئست، تایپ مختص خودش رو برای `results` استفاده می‌کنه که اون تایپ‌ها همین کلاس `VNObservation` رو نهایتا Inherit کردن، و هرکدوم پراپرتی‌های خودشون رو بهش اضافه کردن.



---

## لیبل‌زدن عکس

با استفاده از ویژن می‌تونیم عکس‌ها رو لیبل بزنیم و براساس آبجکت‌های داخل‌شون دسته‌بندی کنیم و روشون سرچ بزنیم. برای این کار از `VNClassifyImageRequest` استفاده می‌کنیم. 

- [مستندات اپل با عنوان Classifying images for categorization and search](https://developer.apple.com/documentation/vision/classifying-images-for-categorization-and-search)
- [ریکوئست `VNClassifyImageRequest`](https://developer.apple.com/documentation/vision/vnclassifyimagerequest)

## ریکوئست `VNGenerateImageFeaturePrint`

این ریکوئست پردازشش رو روی عکس‌ها انجام میده و یه دیتا بعنوان خروجی در نظر می‌گیره. بعد می‌تونیم با استفاده از متد مشخص‌شده، اقدام به محاسبه شباهت عکس‌ها براساس اون دیتا بکنیم.

برای آشنایی می‌تونیم از لینک‌های زیر استفاده کنیم.

- [پروژه نمونه اپل](https://developer.apple.com/documentation/vision/analyzing-image-similarity-with-feature-print)
- [مستندات رسمی اپل](https://developer.apple.com/documentation/vision/vngenerateimagefeatureprintrequest)
- [مقایسه عکس‌ها با استفاده از ویژن](https://medium.com/@kamil.tustanowski/comparing-images-using-the-vision-framework-ff13291901ff)

## تشخیص فرد در عکس

این کار با استفاده از ریکوئست `VNGeneratePersonSegmentationRequest` انجام میشه. برای مثال با استفاده ازین ریکوئست می‌تونیم شخص رو توی عکس شناسایی کنیم و بعدش بک‌گراند پشت سر شخص رو تغییر بدیم. 

همچنین برای این کار، ریکوئست دیگه‌ای هم داریم. بعنوان مثال جایی از مستندات اپل گفته شده که پروژه نمونه:
- اگه تعداد چهره‌های یک عکس کمتر یا برابر ۴ باشه، از `VNGeneratePersonInstanceMaskRequest` استفاده شده
- اگه تعداد چهره‌های یک عکس بیشتر از ۴ باشه، از `VNGeneratePersonSegmentationRequest` استفاده شده

برای توضیح بیشتر و بررسی نمونه کد، می‌تونیم مستندات خود اپل رو چک کنیم.


- ریکوئست [`VNGeneratePersonSegmentationRequest`](https://developer.apple.com/documentation/vision/vngeneratepersonsegmentationrequest)
- [مستندات اپل با عنوان Applying Matte Effects to People in Images and Video](https://developer.apple.com/documentation/vision/applying-matte-effects-to-people-in-images-and-video)
- ریکوئست [`VNGeneratePersonInstanceMaskRequest`](https://developer.apple.com/documentation/vision/vngeneratepersoninstancemaskrequest)
- [مستندات اپل با عنوان Segmenting and colorizing individuals from a surrounding scene](https://developer.apple.com/documentation/vision/segmenting-and-colorizing-individuals-from-a-surrounding-scene)

## ریکوئست تشخیص فعالیت بدنی

این کار با استفاده از ریکوئست `VNDetectHumanBodyPoseRequest` انجام میشه. 

برای توضیح بیشتر و بررسی نمونه کد، می‌تونیم مستندات خود اپل رو چک کنیم.

- ریکوئست [`VNDetectHumanBodyPoseRequest`](https://developer.apple.com/documentation/vision/vndetecthumanbodyposerequest)
- [مستندات اپل با عنوان Detecting Human Actions in a Live Video Feed](https://developer.apple.com/documentation/vision/applying-matte-effects-to-people-in-images-and-video)

## تشخیص سند متنی

با استفاده از ریکوئست [`VNDetectDocumentSegmentationRequest`](https://developer.apple.com/documentation/vision/vndetectdocumentsegmentationrequest) این امکان رو داریم تا اسناد متنی رو توی عکس‌ها شناسایی کنیم.

## نمره‌دهی زیبایی عکس

این کار با استفاده از ریکوئست [`VNCalculateImageAestheticsScoresRequest`](https://developer.apple.com/documentation/vision/vncalculateimageaestheticsscoresrequest) انجام میشه.

## بررسی محدوده اصلی عکس

با استفاده از ویژن می‌تونیم عکس رو براساس روند خاصی بررسی کنیم و نتیجه‌اش محدوده خاصی از عکس باشه. این روند خاص یکی از دو حالت زیر هست:
- بررسی براساس آبجکت خاص
- بررسی براساس تشخیص محدوده اصلی عکس

لینک‌های مربوطه:
- [ریکوئست `VNGenerateAttentionBasedSaliencyImageRequest`](https://developer.apple.com/documentation/vision/vngenerateattentionbasedsaliencyimagerequest)
- [ریکوئست `VNGenerateObjectnessBasedSaliencyImageRequest`](https://developer.apple.com/documentation/vision/vngenerateobjectnessbasedsaliencyimagerequest)
- [مستندات اپل با عنوان Cropping Images Using Saliency](https://developer.apple.com/documentation/vision/cropping-images-using-saliency)
- [مستندات اپل با عنوان Highlighting Areas of Interest in an Image Using Saliency](https://developer.apple.com/documentation/vision/highlighting-areas-of-interest-in-an-image-using-saliency)

## تشخیص مستطیل

از ریکوئست [`VNDetectRectanglesRequest`](https://developer.apple.com/documentation/vision/vndetectrectanglesrequest) برای تشخیص مستطیل توی عکس‌ها استفاده میشه.

## تشخیص کیفیت عکس چهره

از ریکوئست [`VNDetectFaceCaptureQualityRequest`](https://developer.apple.com/documentation/vision/vndetectfacecapturequalityrequest) برای تشخیص کیفیت عکس چهره توی عکس‌ها استفاده میشه.

## تشخیص نقاط چهره

از ریکوئست [`VNDetectFaceLandmarksRequest`](https://developer.apple.com/documentation/vision/vndetectfacelandmarksrequest) برای تشخیص نقاط چهره توی عکس‌ها استفاده میشه.

## تشخیص محدوده چهره

از ریکوئست [`VNDetectFaceRectanglesRequest`](https://developer.apple.com/documentation/vision/vndetectfacerectanglesrequest) برای تشخیص محدوده چهره توی عکس‌ها استفاده میشه.

## تشخیص محدوده فرد

از ریکوئست [`VNDetectHumanRectanglesRequest`](https://developer.apple.com/documentation/vision/vndetecthumanrectanglesrequest) برای تشخیص محدوده فرد توی عکس‌ها استفاده میشه.

## تشخیص نقاط بدن

از ریکوئست [`VNDetectHumanBodyPoseRequest`](https://developer.apple.com/documentation/vision/vndetecthumanbodyposerequest) برای تشخیص نقاط بدن توی عکس‌ها استفاده میشه.

## تشخیص نقاط دست

از ریکوئست [`VNDetectHumanHandPoseRequest`](https://developer.apple.com/documentation/vision/vndetecthumanhandposerequest) برای تشخیص نقاط دست توی عکس‌ها استفاده میشه.

## تشخیص حیوان

از ریکوئست [`VNRecognizeAnimalsRequest`](https://developer.apple.com/documentation/vision/vnrecognizeanimalsrequest) برای تشخیص حیوان توی عکس‌ها استفاده میشه.

## تشخیص بارکد

از ریکوئست [`VNDetectBarcodesRequest`](https://developer.apple.com/documentation/vision/vndetectbarcodesrequest) برای تشخیص بارکد توی عکس‌ها استفاده میشه.

## تشخیص محدوده متن

از ریکوئست [`VNDetectTextRectanglesRequest`](https://developer.apple.com/documentation/vision/vndetecttextrectanglesrequest) برای تشخیص محدوده متن توی عکس‌ها استفاده میشه.

## تشخیص متن

از ریکوئست [`VNRecognizeTextRequest`](https://developer.apple.com/documentation/vision/vnrecognizetextrequest) برای تشخیص متن توی عکس‌ها استفاده میشه.

## تشخیص آبجکت اصلی جلو دوربین

از ریکوئست [`VNGenerateForegroundInstanceMaskRequest`](https://developer.apple.com/documentation/vision/vngenerateforegroundinstancemaskrequest) برای تشخیص آبجکت اصلی جلو دوربین توی عکس‌ها استفاده میشه.

</div>