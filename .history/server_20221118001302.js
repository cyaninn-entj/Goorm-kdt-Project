// express 라이브러리 첨부
const express =require('express'); 

//express 라이브러리 사용
const app = express();

// listen () 함수는 두개의 파라미터를 필요로 함
// listen(서버를 오픈할 포트번호, function(){서버가 오픈되면 실행할 코드})

app.listen(8080, function(){
  console.log('listening on 8080'); // 8080 포트로 들어오면 실행 
});

