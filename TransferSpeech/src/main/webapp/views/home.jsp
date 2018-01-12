<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<style>
textarea {
	resize: none;
	width: 100%;
}

.conDiv {
	padding: 10px 200px 10px 200px;
}

#btn-mic, #btn-tra, #btn-tts {
	text-align: center;
	min-width: 160px;
}

#btn-mic span {
	display: inline-block;
	margin: 1px 0 0 5px;
	width: 10px;
	height: 10px;
	border: solid 1px #fff;
	background: #bbb;
	border-radius: 50%;
}

#btn-mic.on span {
	background: red;
}
</style>
<title>| Tansfer Speech |</title>
</head>
<body>

	<div class="container-fluid">
		<div class="row conDiv">
			<div class="col-xs-5 col-sm-5 col-md-5">
				<textarea id="beforeTa" rows="20" cols="100" readonly="readonly"></textarea>
			</div>

			<div class="col-xs-2 col-sm-2 col-md-2">
				<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
			</div>

			<div class="col-xs-5 col-sm-5 col-md-5">
				<textarea id="afterTa" rows="20" cols="100" readonly="readonly"></textarea>
			</div>
		</div>
		<div class="row conDiv">
			<span class="interim" id="interim_span"></span>
		</div>
		<div class="row conDiv">
			<div class="col-xs-12 col-sm-12 col-md-12">
				<button id="btn-mic" class="off btn btn-success">마이크<span></span></button>
				<button id="btn-tra" class="btn btn-success">번역</button>
				<button id="btn-tts" class="btn btn-success">음성합성</button>
			</div>
		</div>
	</div>

	<!-- ---------------------------------------- JavaScript ---------------------------------------- -->

	<script type="text/javascript"
		src="//ajax.googleapis.com/ajax/libs/prototype/1.6.0.3/prototype.js"></script>
	<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
	<script>
		// JavaScript & jQuery 충돌 방지
		jQuery.noConflict ();
		
		$(function() {
			
			if (typeof webkitSpeechRecognition != 'function') {
				alert('크롬에서만 동작 합니다.');
				return false;
			}

			var recognition = new webkitSpeechRecognition();
			var isRecognizing = false;
			var ignoreOnend = false;
			var finalTranscript = '';
			var $btnMic = $('#btn-mic');

			recognition.continuous = true;
			recognition.interimResults = true;

			/* 마이크 on */
			recognition.onstart = function() {
				console.log('onstart', arguments);
				isRecognizing = true;

				$btnMic.attr('class', 'on btn btn-success');
			};

			/* 마이크 off */
			recognition.onend = function() {
				console.log('onend', arguments);
				isRecognizing = false;

				if (ignoreOnend) {
					return false;
				}

				$btnMic.attr('class', 'off btn btn-success');
				if (!finalTranscript) {
					console.log('empty finalTranscript');
					return false;
				}
			};

			/* 음성을 반환할 때 실행 */
			recognition.onresult = function(event) {
				console.log('onresult', event.results);

				var interimTranscript = '';
				if (typeof (event.results) == 'undefined') {
					recognition.onend = null;
					recognition.stop();
					return;
				}

				for (var i = event.resultIndex; i < event.results.length; ++i) {
					if (event.results[i].isFinal) {
						finalTranscript += event.results[i][0].transcript;
					} else {
						interimTranscript += event.results[i][0].transcript;
					}
				}

				/* 텍스트 이동 */
				finalTranscript = capitalize(finalTranscript);
				beforeTa.innerHTML = linebreak(finalTranscript);
				interim_span.innerHTML = linebreak(interimTranscript);

				/* 입력된 로그 확인 */
				console.log('finalTranscript', finalTranscript);
				console.log('interimTranscript', interimTranscript);
				
			};

			/* 번역 버튼 */
			$('#btn-tra').click(function() {
				if($('#beforeTa').val()!=''){
					$('#afterTa').val($('#beforeTa').val());
					beforeTa.innerHTML = '';
					finalTranscript = '';
				}else{
					alert('비어있습니다.');
				}
			});

			/* error */
			recognition.onerror = function(event) {
				console.log('onerror', event);

				if (event.error == 'no-speech') {
					ignoreOnend = true;
				} else if (event.error == 'not-allowed') {
					ignoreOnend = true;
				}

				$btnMic.attr('class', 'off');
			};

			var two_line = /\n\n/g;
			var one_line = /\n/g;
			var first_char = /\S/;

			function linebreak(s) {
				return s.replace(two_line, '<p></p>').replace(one_line, '<br>');
			}

			function capitalize(s) {
				return s.replace(first_char, function(m) {
					return m.toUpperCase();
				});
			}

			function start(event) {
				if (isRecognizing) {
					recognition.stop();
					return;
				}
				recognition.lang = 'ko-KR';
				recognition.start();
				ignoreOnend = false;

				finalTranscript = '';
				beforeTa.innerHTML = '';
				interim_span.innerHTML = '';
			}

			function textToSpeech(text) {
				console.log('textToSpeech', arguments);

				speechSynthesis.speak(new SpeechSynthesisUtterance(text));
			}

			/**
			 * requestServer
			 * key - AIzaSyDiMqfg8frtoZflA_2LPqfGdpjmgTMgWhg
			 */
			function requestServer() {
				$
						.ajax({
							method : 'post',
							url : 'https://www.google.com/speech-api/v2/recognize?output=json&lang=en-us&key=AIzaSyDiMqfg8frtoZflA_2LPqfGdpjmgTMgWhg',
							data : '/examples/speech-recognition/hello.wav',
							contentType : 'audio/l16; rate=16000;', // 'audio/x-flac; rate=44100;',
							success : function(data) {

							},
							error : function(xhr) {

							}
						});
			}

			/* 음성 녹음 */
			$btnMic.click(start);
			
			/* 음성 출력 */
			$('#btn-tts').click(function() {
				textToSpeech($('#afterTa').val() || '전 음성 인식된 글자를 읽습니다.');
			});
		});
	</script>

</body>
</html>
