# 인천대학교 캡스톤디자인 졸업작품<br>
> 시각장애인을 위한 제품 정보 안내<br>
#### 기획 의도
- 시각 장애인은 제품을 선택할 때 제품의 상단에 위치한 특수 점자를 통해 제품에 대한 정보를 습득합니다. 그러나 점자의 설명이 '음료'와 같은  단순한 표기로만 이루어져 있어 선택하는데 있어 어려움을 겪고 있으며 이를 해결하기 위한 방안을 구상하였습니다.
![스크린샷 2021-06-29 오후 12 26 09](https://user-images.githubusercontent.com/48645631/123732792-693a6380-d8d5-11eb-9980-a0a042ad8112.png)

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

