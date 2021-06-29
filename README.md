# 인천대학교 캡스톤디자인 졸업작품<br>
> 시각장애인을 위한 제품 정보 안내<br>
#### 기획 의도
- 시각 장애인은 제품을 선택할 때 제품의 상단에 위치한 특수 점자를 통해 제품에 대한 정보를 습득합니다. 그러나 점자의 설명이 '음료'와 같은  단순한 표기로만 이루어져 있어 선택하는데 있어 어려움을 겪고 있으며 이를 해결하기 위한 방안을 구상하였습니다.
![스크린샷 2021-06-29 오후 12 26 09](https://user-images.githubusercontent.com/48645631/123732792-693a6380-d8d5-11eb-9980-a0a042ad8112.png)

#### WorkFlow
![ezgif com-resize](https://user-images.githubusercontent.com/48645631/123733751-12358e00-d8d7-11eb-8871-0719aabb4f45.gif) ![칠성사이다 추론 자료](https://user-images.githubusercontent.com/48645631/123734611-9c322680-d8d8-11eb-8fe4-8ef998ba2beb.gif)

- Flow (1~4 반복)
  1. 제품의 정보를 카메라를 통해 리딩합니다. 앱 실행 시 즉시 시작합니다.
  2. 바코드 또는 이미지를 통해 제품의 정보를 리딩 후 제품의 정보를 요청합니다.
  3. 제품의 정보를 바탕으로 TTS를 통해 안내를 합니다.
  4. 음성 안내가 끝난 후 다시 리딩을 시작합니다

- Logic
  1. 바코드와 ImageClassification 중 우선 순위는 바코드
  2. 현재 보여지는 카메라 View에서 3초 간격으로 화면을 캡처 후 inference를 시작합니다. 이 때 80% 이상의 confidence에 대해서만 신뢰
  3. [미구현] 이미지 캡처의 성능 향상을 위해 이미지를 캐싱하여 가지고 있다가 바코드에 대한 인식이 성공할 경우, 해당하는 제품과 이미지를 TF 모델 향상에 이용
 
#### 발표 
- 
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

