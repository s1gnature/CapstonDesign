# 인천대학교 캡스톤디자인 졸업작품<br>
> 시각장애인을 위한 제품 정보 안내<br>
#### 기획 의도
- 시각 장애인은 제품을 선택할 때 제품의 상단에 위치한 특수 점자를 통해 제품에 대한 정보를 습득합니다. 그러나 점자의 설명이 '음료'와 같은  단순한 표기로만 이루어져 있어 선택하는데 있어 어려움을 겪고 있으며 이를 해결하기 위한 방안을 구상하였습니다.
![스크린샷 2021-06-29 오후 12 26 09](https://user-images.githubusercontent.com/48645631/123732792-693a6380-d8d5-11eb-9980-a0a042ad8112.png)

#### WorkFlow
![ezgif com-resize](https://user-images.githubusercontent.com/48645631/123733751-12358e00-d8d7-11eb-8871-0719aabb4f45.gif) ![칠성사이다 추론 자료](https://user-images.githubusercontent.com/48645631/123734611-9c322680-d8d8-11eb-8fe4-8ef998ba2beb.gif)
<br>　　_디바이스 화면 녹화_　　　　　　　_TFLite Inference Log_

- Flow (1~4 반복)
  1. 제품의 정보를 카메라를 통해 리딩합니다. 앱 실행 시 즉시 시작합니다.
  2. 바코드 또는 이미지를 통해 제품의 정보를 리딩 후 제품의 정보를 요청합니다.
  3. 제품의 정보를 바탕으로 TTS를 통해 안내를 합니다.
  4. 음성 안내가 끝난 후 다시 리딩을 시작합니다

- Logic
  1. 바코드와 ImageClassification 중 우선 순위는 바코드
  2. 현재 보여지는 카메라 View에서 3초 간격으로 화면을 캡처 후 inference를 시작합니다. 이 때 80% 이상의 confidence에 대해서만 신뢰
  3. _[미구현]_ 이미지 캡처의 성능 향상을 위해 이미지를 캐싱하여 가지고 있다가 바코드에 대한 인식이 성공할 경우, 해당하는 제품과 이미지를 TF 모델 향상에 이용

#### TroubleShooting
  1. TFLite 모델의 Inference가 현저히 떨어지는 현상
  > TFLite iOS의 image size가 32x32로 크롭한 후 input으로 사용되는 것을 확인
  > model 학습 시 제품의 전체 사진, resizing 된 사진, 제품의 중간 부분의 사진(_key point, 제품의 특징이 담긴 사진_)을 추가 학습
  2. AVCaptureMetadataOutput().rectOfInterest의 화면 전체화
  > 레퍼런스로 사용한 기존의 리딩([QRReader](https://github.com/s1gnature/INU_Corona_QRReader))은 화면 중앙에서만 인식이 가능했음
  > rectOfInterest를 제거하면 구역이 전체 화면이 됨
  > 이후 Focus Zone을 안내하는 UI를 그려놓은 AVCaptureVideoPreviewLayer를 제거함
    
#### 후기
> 여태 토이 프로젝트나 해온 프로젝트가 카메라를 이용하는 기능들이 없어 구현하는데에 많은 자료를 참고하고 시간을 들였었다. 특히 저번에 미리 구현해놓은 QRReader가 많> 은 도움이 되었고 Layer나 BezierPath 등의 무언가를 그리는 작업이 굉장히 까다로웠다. 
> 또한 AVCaptureSession에서 캡쳐를 시작하거나, 캡쳐를 성공했을 때 데이터를 ViewController로 넘겨주는 등의 작업을 위해서 Protocol, Delegate Pattern에 대한 이해가 더욱 잘 되었던 프로젝트 였다.
> 다만 완성도가 기대에 비해 많이 떨어졌고(TF 모델의 성능에 대한) 발전 가능성이 있는 작품인 만큼 개선을 통해 더 나은 사용성을 제공하고 싶은 생각이 든다.

#### 발표 
[![시연 영상](http://img.youtube.com/vi/n_91SqxkM08/0.jpg)](https://youtu.be/n_91SqxkM08) 

#### 졸업작품 제출 및 기능 설명
- [아이디어붐](http://www.ideaboom.net/page/project_detail.php?seq=2128)

#### Library
- [TFLite](https://www.tensorflow.org/lite?hl=ko)

#### 기능 개발
- [QRReader](https://github.com/s1gnature/INU_Corona_QRReader) 를 레퍼런스로 한 BarcodeReader View 
  - AVMetaDataObject.ObjectType: [ean8, ean13]
- TFLite Model Quantazation Type: uInt8
- TTS: AVutterance, AVSpeechSynthesizer

License
----

