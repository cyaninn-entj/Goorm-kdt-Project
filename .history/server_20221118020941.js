// express 라이브러리 첨부
const express =require('express'); 

//express 라이브러리 사용
const app = express();

const bodyParser= require('body-parser');
app.use(bodyParser.urlencoded({extended : true}));
// listen () 함수는 두개의 파라미터를 필요로 함
// listen(서버를 오픈할 포트번호, function(){서버가 오픈되면 실행할 코드})

var db;

const MongoClient = require('mongodb').MongoClient; // 부르기
MongoClient.connect('mongodb+srv://admin:qwer1234@cluster0.twk3puq.mongodb.net/?retryWrites=true&w=majority', function(에러, client){

  if(에러)  return console.log(에러);
  
  db= client.db('goorm-app'); 

  db.collection('post').insertOne({이름: 'park', 나이 : 26 }, function(에러, 결과){
    console.log('저장완료');
  });

  app.listen(8080, function(){
    console.log('listening on 8080'); // 8080 포트로 들어오면 실행 
  });

})


// app.listen(8080, function(){
//   console.log('listening on 8080'); // 8080 포트로 들어오면 실행 
// });

app.get('/pet', function(요청, 응답){
 응답.send('펫쇼핑할 수 있는 사이트');
});

app.get('/beauty', function(요청, 응답){
  응답.send('뷰티용품 쇼핑 페이지임');
 });

 app.get('/', function(요청, 응답){
  응답.sendFile(__dirname + '/index.html');
 });

 app.get('/write', function(요청, 응답){
  응답.sendFile(__dirname + '/write.html');
 });

 app.post('/add',function(요청,응답){
응답.send('전송완료')
console.log(요청.body.title);
console.log(요청.body.date);
db
 });