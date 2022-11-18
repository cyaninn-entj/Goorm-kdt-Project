//환경 변수 저장
require('dotenv').config()

// express 라이브러리 첨부
const express =require('express'); 

//express 라이브러리 사용
const app = express();

const bodyParser= require('body-parser');
app.use(bodyParser.urlencoded({extended : true}));
// listen () 함수는 두개의 파라미터를 필요로 함
// listen(서버를 오픈할 포트번호, function(){서버가 오픈되면 실행할 코드})

app.set('view engine', 'ejs');

app.use('/public', express.static('public'));// public css 등록 

const methodOverride = require('method-override')
app.use(methodOverride('_method'))

var db;

const MongoClient = require('mongodb').MongoClient; // 부르기
MongoClient.connect(process.env.DB_URL, function(에러, client){

  if(에러)  return console.log(에러);
  
  db= client.db('goorm-app'); 

  // db.collection('post').insertOne({이름: 'park', 나이 : 26 }, function(에러, 결과){
  //   console.log('저장완료');
  // });

  app.listen(process.env.PORT, function(){
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
  // 응답.sendFile(__dirname + '/index.html');
  응답.render('index.ejs');
 });

 app.get('/write', function(요청, 응답){
  // 응답.sendFile(__dirname + '/write.html');
  응답.render('write.ejs');
 });

 app.post('/add',function(요청,응답){
  
응답.send('전송완료')
console.log(요청.body.title);
console.log(요청.body.date);
db.collection('counter').findOne({name: '게시물갯수'}, function(에러, 결과){
  console.log(결과.totalPost)
  var 총게시물갯수 = 결과.totalPost;
 var 저장할거 = {_id: 총게시물갯수+1,제목: 요청.body.title, 날짜: 요청.body.date, 작성자 : 요청.};

  db.collection('post').insertOne({_id: 총게시물갯수+1,제목: 요청.body.title, 날짜: 요청.body.date}, function(){
    console.log('저장완료');
    // 콜백함수는 순차적  여기서 total +1 시켜야함
    db.collection('counter').updateOne({name: '게시물갯수' },{ $inc :{totalPost:1} },function(에러, 결과){ //총게시물 업데이트
      if(에러) {return console.log(에러)}
    });

  });

});

 });

 app.get('/list',function(요청,응답){
  db.collection('post').find().toArray(function(에러, 결과){
    console.log(결과);
    //db 가져오면서 결과를 list.ejs 로 보내기
    //posts 라는 이름으로 결과를 보내기 
    응답.render('list.ejs',{posts: 결과});
  });

  // 무슨 무슨 데이터를 꺼내주세요

 });


 app.delete('/delete', function(요청, 응답){
  console.log(요청.body);
 요청.body._id= parseInt(요청.body._id);
  db.collection('post').deleteOne(요청.body,function(에러, 결과){
    console.log('삭제완료');
    응답.status(200).send({message: '성공. '}); // 응답 확인하기
    //counter 에서도 값 변경
    // db.collection('counter').updateOne({name: '게시물갯수' },{ $inc :{totalPost:-1} },function(에러, 결과){ //총게시물 업데이트
    //   if(에러) {return console.log(에러)}
    // });


      }   )
 })

 //detail 로 접속하면 detail.ejs 보여줌

 app.get('/detail/:id', function(요청, 응답){
  db.collection('post').findOne({_id: parseInt(요청.params.id)}, function(에러, 결과){
    console.log(결과)
    응답.render('detail.ejs',{ data : 결과});
  })

 })

 app.get('/edit/:id',function(요청,응답){
  db.collection('post').findOne({_id: parseInt(요청.params.id)}, function(에러, 결과){
    console.log(결과)
    응답.render('edit.ejs',{post: 결과} ) // post 라는 이름으로 쏴주기
  })
 });

 app.put('/edit', function(요청, 응답){ 
  db.collection('post').updateOne( {_id : parseInt(요청.body.id) }, { $set : { 제목 : 요청.body.title , 날짜 : 요청.body.date }}, 
    function(에러,결과){ 
    
    console.log('수정완료') 
    console.log(요청.body)
      응답.redirect('/list')
  }); 
}); 

const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const session = require('express-session');

app.use(session({secret : '비밀코드', resave : true, saveUninitialized: false}));
app.use(passport.initialize());
app.use(passport.session());  

app.get('/login', function(요청, 응답){
  응답.render('login.ejs')
});

app.post('/login',passport.authenticate('local',{
  failureRedirect : '/fail'
}), function(요청, 응답){
  응답.redirect('/')
});

app.get('/mypage', 로그인했니,function (요청, 응답) {
  console.log(요청.user); //요청에 user deserialize 가 있다. 
  응답.render('mypage.ejs', {사용자: 요청.user})
}) 

//로그인 여부를 확인하는 미들웨어
function 로그인했니(요청, 응답, next) { 
  if (요청.user) { 
    next() 
  } 
  else { 
    응답.send('로그인안하셨는데요?') 
  } 
} 

passport.use(new LocalStrategy({
  usernameField: 'id',
  passwordField: 'pw',
  session: true,
  passReqToCallback: false,
}, function (입력한아이디, 입력한비번, done) {
  //console.log(입력한아이디, 입력한비번);
  db.collection('login').findOne({ id: 입력한아이디 }, function (에러, 결과) {
    if (에러) return done(에러)

    if (!결과) return done(null, false, { message: '존재하지않는 아이디요' })
    if (입력한비번 == 결과.pw) {
      return done(null, 결과)
    } else {
      return done(null, false, { message: '비번틀렸어요' })
    }
  })
}));

// 세션을 저장시키는 코드 (로그인성공시)
passport.serializeUser(function (user, done) {
  done(null, user.id)
});

// 마이페이지에 접속할때 사용
passport.deserializeUser(function (아이디, done) {
  db.collection('login').findOne({ id: 아이디 }, function (에러, 결과) {
    done(null, 결과)
  })
}); 

// 회원가입  
app.post('/register', function (요청, 응답) {
  db.collection('login').insertOne({ id: 요청.body.id, pw: 요청.body.pw }, function (에러, 결과) {
    응답.redirect('/')
  })
})