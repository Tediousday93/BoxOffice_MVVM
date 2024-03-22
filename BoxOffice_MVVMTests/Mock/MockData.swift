//
//  MockData.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/11.
//

import Foundation

struct MockData {
    static let sampleImageData = Data(base64Encoded: sampleImageString)!
    
    static let dailyBoxOffice = """
    {"boxOfficeResult":{"boxofficeType":"일별 박스오피스","showRange":"20120101~20120101","dailyBoxOfficeList":[{"rnum":"1","rank":"1","rankInten":"0","rankOldAndNew":"OLD","movieCd":"20112207","movieNm":"미션임파서블:고스트프로토콜","openDt":"2011-12-15","salesAmt":"2776060500","salesShare":"36.3","salesInten":"-415699000","salesChange":"-13","salesAcc":"40541108500","audiCnt":"353274","audiInten":"-60106","audiChange":"-14.5","audiAcc":"5328435","scrnCnt":"697","showCnt":"3223"},{"rnum":"2","rank":"2","rankInten":"1","rankOldAndNew":"OLD","movieCd":"20110295","movieNm":"마이 웨이","openDt":"2011-12-21","salesAmt":"1189058500","salesShare":"15.6","salesInten":"-105894500","salesChange":"-8.2","salesAcc":"13002897500","audiCnt":"153501","audiInten":"-16465","audiChange":"-9.7","audiAcc":"1739543","scrnCnt":"588","showCnt":"2321"},{"rnum":"3","rank":"3","rankInten":"-1","rankOldAndNew":"OLD","movieCd":"20112621","movieNm":"셜록홈즈 : 그림자 게임","openDt":"2011-12-21","salesAmt":"1176022500","salesShare":"15.4","salesInten":"-210328500","salesChange":"-15.2","salesAcc":"10678327500","audiCnt":"153004","audiInten":"-31283","audiChange":"-17","audiAcc":"1442861","scrnCnt":"360","showCnt":"1832"},{"rnum":"4","rank":"4","rankInten":"0","rankOldAndNew":"OLD","movieCd":"20113260","movieNm":"퍼펙트 게임","openDt":"2011-12-21","salesAmt":"644532000","salesShare":"8.4","salesInten":"-75116500","salesChange":"-10.4","salesAcc":"6640940000","audiCnt":"83644","audiInten":"-12225","audiChange":"-12.8","audiAcc":"895416","scrnCnt":"396","showCnt":"1364"},{"rnum":"5","rank":"5","rankInten":"0","rankOldAndNew":"OLD","movieCd":"20113271","movieNm":"프렌즈: 몬스터섬의비밀 ","openDt":"2011-12-29","salesAmt":"436753500","salesShare":"5.7","salesInten":"-89051000","salesChange":"-16.9","salesAcc":"1523037000","audiCnt":"55092","audiInten":"-15568","audiChange":"-22","audiAcc":"202909","scrnCnt":"290","showCnt":"838"},{"rnum":"6","rank":"6","rankInten":"1","rankOldAndNew":"OLD","movieCd":"19940256","movieNm":"라이온 킹","openDt":"1994-07-02","salesAmt":"507115500","salesShare":"6.6","salesInten":"-114593500","salesChange":"-18.4","salesAcc":"1841625000","audiCnt":"45750","audiInten":"-11699","audiChange":"-20.4","audiAcc":"171285","scrnCnt":"244","showCnt":"895"},{"rnum":"7","rank":"7","rankInten":"-1","rankOldAndNew":"OLD","movieCd":"20113381","movieNm":"오싹한 연애","openDt":"2011-12-01","salesAmt":"344871000","salesShare":"4.5","salesInten":"-107005500","salesChange":"-23.7","salesAcc":"20634684500","audiCnt":"45062","audiInten":"-15926","audiChange":"-26.1","audiAcc":"2823060","scrnCnt":"243","showCnt":"839"},{"rnum":"8","rank":"8","rankInten":"0","rankOldAndNew":"OLD","movieCd":"20112709","movieNm":"극장판 포켓몬스터 베스트 위시「비크티니와 백의 영웅 레시라무」","openDt":"2011-12-22","salesAmt":"167809500","salesShare":"2.2","salesInten":"-45900500","salesChange":"-21.5","salesAcc":"1897120000","audiCnt":"24202","audiInten":"-7756","audiChange":"-24.3","audiAcc":"285959","scrnCnt":"186","showCnt":"348"},{"rnum":"9","rank":"9","rankInten":"0","rankOldAndNew":"OLD","movieCd":"20113311","movieNm":"앨빈과 슈퍼밴드3","openDt":"2011-12-15","salesAmt":"137030000","salesShare":"1.8","salesInten":"-35408000","salesChange":"-20.5","salesAcc":"3416675000","audiCnt":"19729","audiInten":"-6461","audiChange":"-24.7","audiAcc":"516289","scrnCnt":"169","showCnt":"359"},{"rnum":"10","rank":"10","rankInten":"0","rankOldAndNew":"OLD","movieCd":"20112708","movieNm":"극장판 포켓몬스터 베스트 위시 「비크티니와 흑의 영웅 제크로무」","openDt":"2011-12-22","salesAmt":"125535500","salesShare":"1.6","salesInten":"-40756000","salesChange":"-24.5","salesAcc":"1595695000","audiCnt":"17817","audiInten":"-6554","audiChange":"-26.9","audiAcc":"235070","scrnCnt":"175","showCnt":"291"}]}}
    """.data(using: .utf8)!
    
    static let movieDetails = """
    {"movieInfoResult":{"movieInfo":{"movieCd":"20124079","movieNm":"광해, 왕이 된 남자","movieNmEn":"Masquerade","movieNmOg":"","showTm":"131","prdtYear":"2012","openDt":"20120913","prdtStatNm":"개봉","typeNm":"장편","nations":[{"nationNm":"한국"}],"genres":[{"genreNm":"사극"},{"genreNm":"드라마"}],"directors":[{"peopleNm":"추창민","peopleNmEn":"CHOO Chang-min"}],"actors":[{"peopleNm":"이병헌","peopleNmEn":"LEE Byung-hun","cast":"광해/하선","castEn":""},{"peopleNm":"류승룡","peopleNmEn":"RYU Seung-ryong","cast":"허균","castEn":""},{"peopleNm":"한효주","peopleNmEn":"HAN Hyo-joo","cast":"중전","castEn":""},{"peopleNm":"장광","peopleNmEn":"JANG Kwang","cast":"조내관","castEn":""},{"peopleNm":"김인권","peopleNmEn":"KIM In-kwon","cast":"도부장","castEn":""},{"peopleNm":"심은경","peopleNmEn":"SHIM Eun-kyoung","cast":"사월이","castEn":""},{"peopleNm":"김명곤","peopleNmEn":"KIM Myung-kon","cast":"박충수","castEn":""},{"peopleNm":"박지아","peopleNmEn":"PARK Zi-a","cast":"한상궁","castEn":""},{"peopleNm":"이양희","peopleNmEn":"LEE Yang-hee","cast":"공판","castEn":""},{"peopleNm":"전국향","peopleNmEn":"JEON Guk-hyang","cast":"정상궁","castEn":""},{"peopleNm":"서진원","peopleNmEn":"SEO Jin-won","cast":"도총관","castEn":""},{"peopleNm":"장재현","peopleNmEn":"JANG Jae-hyun","cast":"광해 등불 내관1","castEn":""},{"peopleNm":"정창국","peopleNmEn":"","cast":"자객2","castEn":""},{"peopleNm":"조혜정","peopleNmEn":"","cast":"기미 궁녀1","castEn":""},{"peopleNm":"김남준","peopleNmEn":"","cast":"강원도 현감","castEn":""},{"peopleNm":"이수용","peopleNmEn":"","cast":"칼자국","castEn":""},{"peopleNm":"박윤호","peopleNmEn":"PARK Yoon-ho","cast":"유생4","castEn":""},{"peopleNm":"김지수","peopleNmEn":"","cast":"자객1","castEn":""},{"peopleNm":"박민규","peopleNmEn":"","cast":"광해 등불 내관2","castEn":""},{"peopleNm":"송미정","peopleNmEn":"","cast":"사월이 대역","castEn":""},{"peopleNm":"양준모","peopleNmEn":"","cast":"","castEn":""},{"peopleNm":"원동연","peopleNmEn":"WON Dong-yeon","cast":"홍루몽 선비","castEn":""},{"peopleNm":"김종구","peopleNmEn":"KIM Jong-gu","cast":"광해 어의","castEn":""},{"peopleNm":"주영호","peopleNmEn":"JU Yeong-ho","cast":"광해 별감1","castEn":""},{"peopleNm":"이엘","peopleNmEn":"LEE El","cast":"안개시","castEn":""},{"peopleNm":"전배수","peopleNmEn":"JEON Bae-soo","cast":"형판","castEn":""},{"peopleNm":"이란희","peopleNmEn":"LEE Ran-hee","cast":"수라간 궁녀3","castEn":""},{"peopleNm":"최욱","peopleNmEn":"CHOI Wook","cast":"유생 2","castEn":""},{"peopleNm":"이봉련","peopleNmEn":"LEE Bong-ryeon","cast":"수라간 궁녀1","castEn":""},{"peopleNm":"허성태","peopleNmEn":"HEO Sungtae","cast":"국문장 나장1","castEn":""},{"peopleNm":"김승훈","peopleNmEn":"KIM Seung-hoon","cast":"이방","castEn":""},{"peopleNm":"권은수","peopleNmEn":"GWON Eun-su","cast":"광해수건궁녀","castEn":""},{"peopleNm":"승의열","peopleNmEn":"SEUNG Ui -yeol","cast":"사월 어의","castEn":""},{"peopleNm":"김비비","peopleNmEn":"KIM Bi-bi","cast":"중전 궁녀","castEn":""},{"peopleNm":"한이진","peopleNmEn":"HAN Iee-jin","cast":"하선 포졸1","castEn":""},{"peopleNm":"이은정","peopleNmEn":"","cast":"광해상궁","castEn":""}],"showTypes":[{"showTypeGroupNm":"필름","showTypeNm":"필름"},{"showTypeGroupNm":"필름","showTypeNm":"청각장애인용 자막"},{"showTypeGroupNm":"2D","showTypeNm":"디지털"},{"showTypeGroupNm":"2D","showTypeNm":"디지털 영문자막"},{"showTypeGroupNm":"2D","showTypeNm":"디지털 일어자막"},{"showTypeGroupNm":"2D","showTypeNm":"디지털 가치봄"}],"companys":[{"companyCd":"20100540","companyNm":"리얼라이즈픽쳐스(주)","companyNmEn":"Realies Pictures, Inc.","companyPartNm":"제작사"},{"companyCd":"20110854","companyNm":"(주)씨제이이엔엠","companyNmEn":"CJ ENM Corp.","companyPartNm":"제작사"},{"companyCd":"20110854","companyNm":"(주)씨제이이엔엠","companyNmEn":"CJ ENM Corp.","companyPartNm":"배급사"},{"companyCd":"20110854","companyNm":"(주)씨제이이엔엠","companyNmEn":"CJ ENM Corp.","companyPartNm":"제공"},{"companyCd":"20111391","companyNm":"비엠씨영화전문투자조합","companyNmEn":"","companyPartNm":"공동제공"},{"companyCd":"20114892","companyNm":"컴퍼니케이파트너스 콘텐츠 전문투자조합","companyNmEn":"","companyPartNm":"공동제공"},{"companyCd":"20114895","companyNm":"그린손해보험(주)","companyNmEn":"Green non-life insurance co,. Ltd","companyPartNm":"공동제공"},{"companyCd":"20061365","companyNm":"이수창업투자(주)","companyNmEn":"","companyPartNm":"공동제공"},{"companyCd":"20061361","companyNm":"소빅창업투자(주)","companyNmEn":"","companyPartNm":"공동제공"},{"companyCd":"20123779","companyNm":"에스크베리타스자산운용(주)","companyNmEn":"","companyPartNm":"공동제공"},{"companyCd":"20061362","companyNm":"CJ창업투자(주)","companyNmEn":"CJ Venture Investment","companyPartNm":"공동제공"},{"companyCd":"20123115","companyNm":"MVP창투문화산업투자조합","companyNmEn":"","companyPartNm":"공동제공"},{"companyCd":"20111451","companyNm":"(유)동문파트너즈","companyNmEn":"","companyPartNm":"공동제공"},{"companyCd":"20100109","companyNm":"CJ ENM","companyNmEn":"CJ ENM","companyPartNm":"해외세일즈사"}],"audits":[{"auditNo":"2012-F610","watchGradeNm":"15세이상관람가"}],"staffs":[{"peopleNm":"문성주","peopleNmEn":"MOON Sung-joo","staffRoleNm":"투자"},{"peopleNm":"김호성","peopleNmEn":"KIM Ho-sung","staffRoleNm":"제작"},{"peopleNm":"원동연","peopleNmEn":"WON Dong-yeon","staffRoleNm":"제작"},{"peopleNm":"임상진","peopleNmEn":"IM Sang-jin","staffRoleNm":"제작"},{"peopleNm":"정지훈","peopleNmEn":"JEONG Ji-hoon","staffRoleNm":"프로듀서"},{"peopleNm":"이성두","peopleNmEn":"","staffRoleNm":"라인프로듀서"},{"peopleNm":"김영호","peopleNmEn":"KIM Young-ho","staffRoleNm":"라인프로듀서"},{"peopleNm":"김지수","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"서규선","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"송미정","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"윤지원","peopleNmEn":"YUN Ji-won","staffRoleNm":"제작팀"},{"peopleNm":"강성철","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"정창국","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"이준규","peopleNmEn":"LEE Jun-kyu","staffRoleNm":"제작팀"},{"peopleNm":"김성태","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"박민규","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"조영","peopleNmEn":"","staffRoleNm":"제작팀"},{"peopleNm":"김형준","peopleNmEn":"Jonathan H. KIM","staffRoleNm":"제작관리"},{"peopleNm":"설혜옥","peopleNmEn":"","staffRoleNm":"제작관리"},{"peopleNm":"최시원","peopleNmEn":"","staffRoleNm":"데이타매니저"},{"peopleNm":"이동수","peopleNmEn":"","staffRoleNm":"조감독"},{"peopleNm":"민홍남","peopleNmEn":"","staffRoleNm":"연출팀"},{"peopleNm":"김남준","peopleNmEn":"","staffRoleNm":"연출팀"},{"peopleNm":"표유신","peopleNmEn":"","staffRoleNm":"연출팀"},{"peopleNm":"장재현","peopleNmEn":"JANG Jae-hyun","staffRoleNm":"연출팀"},{"peopleNm":"엄석준","peopleNmEn":"","staffRoleNm":"연출팀"},{"peopleNm":"장미숙","peopleNmEn":"","staffRoleNm":"스크립터"},{"peopleNm":"이윤호","peopleNmEn":"","staffRoleNm":"스토리보드"},{"peopleNm":"차주한","peopleNmEn":"CHA Ju-han","staffRoleNm":"스토리보드"},{"peopleNm":"송선찬","peopleNmEn":"SONG Seon-chan","staffRoleNm":"스토리보드"},{"peopleNm":"정태민","peopleNmEn":"","staffRoleNm":"스토리보드"},{"peopleNm":"홍유리","peopleNmEn":"","staffRoleNm":"현장편집"},{"peopleNm":"허선미","peopleNmEn":"HEO Seon-mi","staffRoleNm":"현장편집"},{"peopleNm":"안소정","peopleNmEn":"","staffRoleNm":"스토리"},{"peopleNm":"황조윤","peopleNmEn":"HWANG Jo-yun","staffRoleNm":"시나리오(각본)"},{"peopleNm":"추창민","peopleNmEn":"CHOO Chang-min","staffRoleNm":"각색"},{"peopleNm":"이태윤","peopleNmEn":"LEE Tae-yoon","staffRoleNm":"촬영"},{"peopleNm":"김동욱","peopleNmEn":"KIM Dong-wook","staffRoleNm":"카메라오퍼레이터"},{"peopleNm":"최재광","peopleNmEn":"","staffRoleNm":"촬영팀"},{"peopleNm":"김성인","peopleNmEn":"","staffRoleNm":"촬영팀"},{"peopleNm":"김정원","peopleNmEn":"KIM Jung-won","staffRoleNm":"촬영팀"},{"peopleNm":"김재광","peopleNmEn":"KIM Jae-gwang","staffRoleNm":"촬영팀"},{"peopleNm":"문성진","peopleNmEn":"Moon seong jin","staffRoleNm":"촬영팀"},{"peopleNm":"이재충","peopleNmEn":"","staffRoleNm":"촬영팀"},{"peopleNm":"김태수","peopleNmEn":"","staffRoleNm":"촬영팀"},{"peopleNm":"김주연","peopleNmEn":"Kim Joo-yeun","staffRoleNm":"촬영팀"},{"peopleNm":"신정길","peopleNmEn":"","staffRoleNm":"촬영팀"},{"peopleNm":"김도균","peopleNmEn":"KIM Do-gyun","staffRoleNm":"그립"},{"peopleNm":"김종배","peopleNmEn":"","staffRoleNm":"그립"},{"peopleNm":"오진영","peopleNmEn":"","staffRoleNm":"그립"},{"peopleNm":"전용훈","peopleNmEn":"JEON Yong-hoon","staffRoleNm":"스테디캠"},{"peopleNm":"김병국","peopleNmEn":"","staffRoleNm":"지미집"},{"peopleNm":"김희승","peopleNmEn":"KIM Hee-seung","staffRoleNm":"지미집"},{"peopleNm":"김민재","peopleNmEn":"KIM Min-jae","staffRoleNm":"촬영장비"},{"peopleNm":"오승철","peopleNmEn":"OH Seung-chul","staffRoleNm":"조명"},{"peopleNm":"이성규","peopleNmEn":"","staffRoleNm":"조명팀"},{"peopleNm":"유혁준","peopleNmEn":"","staffRoleNm":"조명팀"},{"peopleNm":"이동원","peopleNmEn":"LEE Dong-won","staffRoleNm":"조명팀"},{"peopleNm":"김상철","peopleNmEn":"KIM Sang-chul","staffRoleNm":"조명팀"},{"peopleNm":"방현용","peopleNmEn":"","staffRoleNm":"조명팀"},{"peopleNm":"황확성","peopleNmEn":"","staffRoleNm":"조명팀"},{"peopleNm":"한경욱","peopleNmEn":"","staffRoleNm":"조명팀"},{"peopleNm":"김형미","peopleNmEn":"","staffRoleNm":"조명팀"},{"peopleNm":"남경민","peopleNmEn":"NAM Gyeong-min","staffRoleNm":"조명팀"},{"peopleNm":"박지수","peopleNmEn":"PARK Jisoo","staffRoleNm":"조명팀"},{"peopleNm":"박지훈","peopleNmEn":"","staffRoleNm":"조명팀"},{"peopleNm":"황확성","peopleNmEn":"","staffRoleNm":"발전차"},{"peopleNm":"박사옥","peopleNmEn":"PARK Sa-ok","staffRoleNm":"발전차"},{"peopleNm":"이기준","peopleNmEn":"LEE Gi-jun","staffRoleNm":"조명장비"},{"peopleNm":"이상준","peopleNmEn":"LEE Sang-jun","staffRoleNm":"동시녹음"},{"peopleNm":"고동훈","peopleNmEn":"KOH Dong-hun","staffRoleNm":"붐오퍼레이터"},{"peopleNm":"김지아","peopleNmEn":"","staffRoleNm":"붐오퍼레이터"},{"peopleNm":"이동현","peopleNmEn":"","staffRoleNm":"케이블맨"},{"peopleNm":"오흥석","peopleNmEn":"OH Heung-suk","staffRoleNm":"미술/프로덕션 디자인"},{"peopleNm":"김승경","peopleNmEn":"KIM Seung-kyung","staffRoleNm":"아트디렉터"},{"peopleNm":"곽재식","peopleNmEn":"KWAK Jae-sik","staffRoleNm":"아트디렉터"},{"peopleNm":"김슬기","peopleNmEn":"KIM Seul-ki","staffRoleNm":"미술팀"},{"peopleNm":"원연주","peopleNmEn":"","staffRoleNm":"미술팀"},{"peopleNm":"김지현","peopleNmEn":"KIM Ji-hyun","staffRoleNm":"미술팀"},{"peopleNm":"이선정","peopleNmEn":"","staffRoleNm":"미술팀"},{"peopleNm":"이성경","peopleNmEn":"","staffRoleNm":"미술팀"},{"peopleNm":"연상모","peopleNmEn":"","staffRoleNm":"미술팀"},{"peopleNm":"서영희","peopleNmEn":"","staffRoleNm":"미술팀"},{"peopleNm":"김은영","peopleNmEn":"KIM Eun-young","staffRoleNm":"미술팀"},{"peopleNm":"윤일랑","peopleNmEn":"YUN Il-lang","staffRoleNm":"세트"},{"peopleNm":"김학현","peopleNmEn":"","staffRoleNm":"세트팀"},{"peopleNm":"김광섭","peopleNmEn":"KIM Gwang-sub","staffRoleNm":"세트팀"},{"peopleNm":"김동섭","peopleNmEn":"","staffRoleNm":"세트팀"},{"peopleNm":"김현정","peopleNmEn":"Kim Hyun-jung","staffRoleNm":"세트미술팀"},{"peopleNm":"김우리","peopleNmEn":"","staffRoleNm":"세트미술팀"},{"peopleNm":"오유진","peopleNmEn":"OH You-jin","staffRoleNm":"소품"},{"peopleNm":"전재욱","peopleNmEn":"JUN Jae-wook","staffRoleNm":"소품"},{"peopleNm":"오유진","peopleNmEn":"OH You-jin","staffRoleNm":"소품"},{"peopleNm":"서민정","peopleNmEn":"","staffRoleNm":"소품팀"},{"peopleNm":"이정은","peopleNmEn":"LEE Jung-eun","staffRoleNm":"소품팀"},{"peopleNm":"김보미","peopleNmEn":"KIM Bo-mi","staffRoleNm":"소품팀"},{"peopleNm":"서영희","peopleNmEn":"","staffRoleNm":"소품팀"},{"peopleNm":"김철남","peopleNmEn":"KIM Chul-nam","staffRoleNm":"소품팀"},{"peopleNm":"전승훈","peopleNmEn":"","staffRoleNm":"소품팀"},{"peopleNm":"권유진","peopleNmEn":"KWON Yoo-jin","staffRoleNm":"의상"},{"peopleNm":"임정희","peopleNmEn":"","staffRoleNm":"의상"},{"peopleNm":"권유진","peopleNmEn":"KWON Yoo-jin","staffRoleNm":"의상디자이너"},{"peopleNm":"이은이","peopleNmEn":"","staffRoleNm":"의상팀"},{"peopleNm":"박세라","peopleNmEn":"","staffRoleNm":"의상팀"},{"peopleNm":"김진주","peopleNmEn":"KIM Jin-ju","staffRoleNm":"의상팀"},{"peopleNm":"이하나","peopleNmEn":"","staffRoleNm":"의상팀"},{"peopleNm":"이혜란","peopleNmEn":"","staffRoleNm":"의상팀"},{"peopleNm":"김소희","peopleNmEn":"","staffRoleNm":"의상팀"},{"peopleNm":"최유미","peopleNmEn":"CHOI Yu-mi","staffRoleNm":"의상팀"},{"peopleNm":"진승희","peopleNmEn":"","staffRoleNm":"의상팀"},{"peopleNm":"김나현","peopleNmEn":"","staffRoleNm":"의상팀"},{"peopleNm":"조태희","peopleNmEn":"CHO Tae-hee","staffRoleNm":"분장"},{"peopleNm":"최상미","peopleNmEn":"","staffRoleNm":"분장팀"},{"peopleNm":"강혜은","peopleNmEn":"","staffRoleNm":"분장팀"},{"peopleNm":"최유진","peopleNmEn":"","staffRoleNm":"분장팀"},{"peopleNm":"김선희","peopleNmEn":"KIM Seon-hee","staffRoleNm":"분장팀"},{"peopleNm":"이미진","peopleNmEn":"","staffRoleNm":"분장팀"},{"peopleNm":"조강희","peopleNmEn":"","staffRoleNm":"헤어"},{"peopleNm":"조태희","peopleNmEn":"CHO Tae-hee","staffRoleNm":"헤어"},{"peopleNm":"곽태용","peopleNmEn":"KWAK Tae-yong","staffRoleNm":"특수분장"},{"peopleNm":"설하운","peopleNmEn":"","staffRoleNm":"특수분장"},{"peopleNm":"이고운","peopleNmEn":"LEE Go-un","staffRoleNm":"특수분장"},{"peopleNm":"김호식","peopleNmEn":"","staffRoleNm":"특수분장"},{"peopleNm":"김신애","peopleNmEn":"KIM Sin-ae","staffRoleNm":"특수분장"},{"peopleNm":"피대성","peopleNmEn":"PEE Dae-sung","staffRoleNm":"특수분장"},{"peopleNm":"황효균","peopleNmEn":"HWANG Hyo-gyun","staffRoleNm":"특수분장"},{"peopleNm":"조은수","peopleNmEn":"Jo Eun-su","staffRoleNm":"특수분장"},{"peopleNm":"김새봄","peopleNmEn":"","staffRoleNm":"특수분장"},{"peopleNm":"이희은","peopleNmEn":"LEE Hee-eun","staffRoleNm":"특수분장"},{"peopleNm":"박종화","peopleNmEn":"","staffRoleNm":"분장차"},{"peopleNm":"박정률","peopleNmEn":"PARK Jung-ryul","staffRoleNm":"액션/스턴트"},{"peopleNm":"김승필","peopleNmEn":"KIM Seung-phil","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"최광락","peopleNmEn":"Kwangrak Choi","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"김정민","peopleNmEn":"","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"김정민","peopleNmEn":"","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"김용호","peopleNmEn":"","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"이명규","peopleNmEn":"","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"이주원","peopleNmEn":"","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"김철준","peopleNmEn":"Kim Chul-jun","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"이재남","peopleNmEn":"","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"안용우","peopleNmEn":"","staffRoleNm":"액션/스턴트팀"},{"peopleNm":"김승필","peopleNmEn":"KIM Seung-phil","staffRoleNm":"액션/스턴트코디네이터"},{"peopleNm":"한민혁","peopleNmEn":"","staffRoleNm":"액션/스턴트코디네이터"},{"peopleNm":"박철용","peopleNmEn":"","staffRoleNm":"특수효과"},{"peopleNm":"윤대원","peopleNmEn":"YOON Dae-won","staffRoleNm":"특수효과"},{"peopleNm":"박상균","peopleNmEn":"","staffRoleNm":"특수효과팀"},{"peopleNm":"임승배","peopleNmEn":"","staffRoleNm":"특수효과팀"},{"peopleNm":"김도영","peopleNmEn":"","staffRoleNm":"특수효과팀"},{"peopleNm":"남나영","peopleNmEn":"NAM Na-young","staffRoleNm":"편집"},{"peopleNm":"정계현","peopleNmEn":"Jung Kye-hyun","staffRoleNm":"편집팀"},{"peopleNm":"정지연","peopleNmEn":"","staffRoleNm":"편집팀"},{"peopleNm":"김준성","peopleNmEn":"KIM Jun-seong","staffRoleNm":"음악"},{"peopleNm":"모그","peopleNmEn":"Mowg","staffRoleNm":"음악"},{"peopleNm":"김수영","peopleNmEn":"","staffRoleNm":"음악진행"},{"peopleNm":"신라별","peopleNmEn":"","staffRoleNm":"음악진행"},{"peopleNm":"김나래","peopleNmEn":"KIM Na-rae","staffRoleNm":"음악진행"},{"peopleNm":"박성균","peopleNmEn":"","staffRoleNm":"음악진행"},{"peopleNm":"장혁진","peopleNmEn":"","staffRoleNm":"음악진행"},{"peopleNm":"모그","peopleNmEn":"Mowg","staffRoleNm":"음악진행"},{"peopleNm":"이은주","peopleNmEn":"LEE Eun-joo","staffRoleNm":"음악진행"},{"peopleNm":"김지애","peopleNmEn":"","staffRoleNm":"음악진행"},{"peopleNm":"모그","peopleNmEn":"Mowg","staffRoleNm":"작사/작곡/편곡"},{"peopleNm":"김준성","peopleNmEn":"KIM Jun-seong","staffRoleNm":"작사/작곡/편곡"},{"peopleNm":"고예진","peopleNmEn":"","staffRoleNm":"작사/작곡/편곡"},{"peopleNm":"황병준","peopleNmEn":"HWANG Byoung-jun","staffRoleNm":"음악 믹싱/레코딩"},{"peopleNm":"장성학","peopleNmEn":"","staffRoleNm":"음악 믹싱/레코딩"},{"peopleNm":"김준성","peopleNmEn":"KIM Jun-seong","staffRoleNm":"음악 믹싱/레코딩"},{"peopleNm":"이한구","peopleNmEn":"","staffRoleNm":"음악 믹싱/레코딩"},{"peopleNm":"이성진","peopleNmEn":"LEE Seong-jin","staffRoleNm":"사운드"},{"peopleNm":"이승철","peopleNmEn":"LEE Seung-chul","staffRoleNm":"사운드"},{"peopleNm":"한명환","peopleNmEn":"HAN Myung-hwan","staffRoleNm":"사운드믹싱"},{"peopleNm":"정지영","peopleNmEn":"JEONG Ji-young","staffRoleNm":"대사"},{"peopleNm":"최영선","peopleNmEn":"","staffRoleNm":"대사"},{"peopleNm":"남지은","peopleNmEn":"NAM Ji-eun","staffRoleNm":"사운드효과"},{"peopleNm":"정지영","peopleNmEn":"JEONG Ji-young","staffRoleNm":"사운드효과"},{"peopleNm":"한주희","peopleNmEn":"HAN Joo-hee","staffRoleNm":"폴리"},{"peopleNm":"문재홍","peopleNmEn":"MOON Jae-hong","staffRoleNm":"폴리"},{"peopleNm":"김용국","peopleNmEn":"KIM Yong-kook","staffRoleNm":"폴리"},{"peopleNm":"박기영","peopleNmEn":"Park Ki-Young/PARK Gi-yeong","staffRoleNm":"사운드팀"},{"peopleNm":"송윤재","peopleNmEn":"SONG Yoon-jae","staffRoleNm":"사운드팀"},{"peopleNm":"이진호","peopleNmEn":"","staffRoleNm":"홍보/마케팅 진행"},{"peopleNm":"김선미","peopleNmEn":"","staffRoleNm":"홍보/마케팅 진행"},{"peopleNm":"이윤정","peopleNmEn":"","staffRoleNm":"홍보/마케팅 진행"},{"peopleNm":"임완택","peopleNmEn":"","staffRoleNm":"광고디자인"},{"peopleNm":"박지민","peopleNmEn":"","staffRoleNm":"광고디자인"},{"peopleNm":"박찬은","peopleNmEn":"","staffRoleNm":"광고디자인"},{"peopleNm":"박시영","peopleNmEn":"","staffRoleNm":"광고디자인"},{"peopleNm":"김영준","peopleNmEn":"","staffRoleNm":"포스터사진"},{"peopleNm":"윤은한","peopleNmEn":"","staffRoleNm":"스틸"},{"peopleNm":"노주한","peopleNmEn":"NO Ju-han","staffRoleNm":"스틸"},{"peopleNm":"노주한","peopleNmEn":"NO Ju-han","staffRoleNm":"스틸"},{"peopleNm":"한검주","peopleNmEn":"","staffRoleNm":"메이킹필름"},{"peopleNm":"이상호","peopleNmEn":"","staffRoleNm":"메이킹필름"},{"peopleNm":"한명선","peopleNmEn":"","staffRoleNm":"메이킹필름"},{"peopleNm":"김영국","peopleNmEn":"KIM Yeong-guk","staffRoleNm":"메이킹필름"},{"peopleNm":"김서연","peopleNmEn":"","staffRoleNm":"메이킹필름"},{"peopleNm":"김서연","peopleNmEn":"","staffRoleNm":"메이킹필름"},{"peopleNm":"윤성훈","peopleNmEn":"","staffRoleNm":"예고편"},{"peopleNm":"최승원","peopleNmEn":"CHOI Seung-won","staffRoleNm":"예고편"},{"peopleNm":"이방남","peopleNmEn":"","staffRoleNm":"예고편"},{"peopleNm":"김기훈","peopleNmEn":"","staffRoleNm":"예고편"},{"peopleNm":"진영범","peopleNmEn":"","staffRoleNm":"예고편"},{"peopleNm":"신의철","peopleNmEn":"SHIN Eui-chul","staffRoleNm":"예고편"},{"peopleNm":"곽노민","peopleNmEn":"","staffRoleNm":"예고편"},{"peopleNm":"김형운","peopleNmEn":"","staffRoleNm":"광고대행"},{"peopleNm":"정연호","peopleNmEn":"","staffRoleNm":"광고대행"},{"peopleNm":"염혜영","peopleNmEn":"","staffRoleNm":"광고대행"},{"peopleNm":"김진희","peopleNmEn":"","staffRoleNm":"온라인마케팅"},{"peopleNm":"이지영","peopleNmEn":"LEE Ji-young","staffRoleNm":"온라인마케팅"},{"peopleNm":"부희정","peopleNmEn":"","staffRoleNm":"온라인마케팅"},{"peopleNm":"전혜숙","peopleNmEn":"JEON Hye-sook","staffRoleNm":"온라인마케팅"},{"peopleNm":"진상현","peopleNmEn":"","staffRoleNm":"온라인마케팅"},{"peopleNm":"함혜선","peopleNmEn":"","staffRoleNm":"온라인마케팅"},{"peopleNm":"유지남","peopleNmEn":"","staffRoleNm":"온라인마케팅"},{"peopleNm":"신정수","peopleNmEn":"","staffRoleNm":"온라인마케팅"},{"peopleNm":"송대중","peopleNmEn":"","staffRoleNm":"캐스팅디렉터"},{"peopleNm":"임상진","peopleNmEn":"IM Sang-jin","staffRoleNm":"기획"},{"peopleNm":"신민수","peopleNmEn":"SHIN Min-soo","staffRoleNm":"VFX 아티스트"},{"peopleNm":"신선정","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"신혜정","peopleNmEn":"Shin Hye-joung","staffRoleNm":"VFX 아티스트"},{"peopleNm":"심기웅","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"안희경","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"오새봄","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"오석근","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"우지현","peopleNmEn":"WOO Ji Hyun","staffRoleNm":"VFX 아티스트"},{"peopleNm":"유영균","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"윤동욱","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"윤동욱","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"윤성환","peopleNmEn":"YOON Sung-hwan","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김민선","peopleNmEn":"KIM Min-sun","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김민선","peopleNmEn":"KIM Min-sun","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김창연","peopleNmEn":"KIM Chang-yeon","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김태용","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김풍래","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"문상현","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"박명희","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"박미영","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"박성훈","peopleNmEn":"Park Sung-hoon","staffRoleNm":"VFX 아티스트"},{"peopleNm":"박정민","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"하돈수","peopleNmEn":"HA DON SOO","staffRoleNm":"VFX 아티스트"},{"peopleNm":"이효영","peopleNmEn":"LEE Hyo-young","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"전석재","peopleNmEn":"Jun Seok-jae","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"김인석","peopleNmEn":"KIM In-seok","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"김정민","peopleNmEn":"","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"박영준","peopleNmEn":"","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"최걸","peopleNmEn":"","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"김민철","peopleNmEn":"KIM Min-chul","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"강경일","peopleNmEn":"KANG Kyung-il","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"김호섭","peopleNmEn":"","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"조하나","peopleNmEn":"CHO Ha-na","staffRoleNm":"VFX 매니지먼트"},{"peopleNm":"류연","peopleNmEn":"RYU Yeon","staffRoleNm":"DI팀"},{"peopleNm":"김형석","peopleNmEn":"KIM Hyeong-seok","staffRoleNm":"DI팀"},{"peopleNm":"서동원","peopleNmEn":"SEO Dong-won","staffRoleNm":"DI팀"},{"peopleNm":"이종은","peopleNmEn":"LEE Jong-eun","staffRoleNm":"DI팀"},{"peopleNm":"이정민","peopleNmEn":"","staffRoleNm":"DI팀"},{"peopleNm":"정현우","peopleNmEn":"","staffRoleNm":"DI팀"},{"peopleNm":"고민지","peopleNmEn":"","staffRoleNm":"DI팀"},{"peopleNm":"옥임식","peopleNmEn":"OK Im-sik","staffRoleNm":"DI팀"},{"peopleNm":"장지욱","peopleNmEn":"","staffRoleNm":"DI팀"},{"peopleNm":"신정민","peopleNmEn":"SHIN Jung-min","staffRoleNm":"DI팀"},{"peopleNm":"김재민","peopleNmEn":"KIM Jae-min","staffRoleNm":"DI팀"},{"peopleNm":"강상우","peopleNmEn":"KANG Sang-woo","staffRoleNm":"DI팀"},{"peopleNm":"최인선","peopleNmEn":"CHOI In-seon","staffRoleNm":"DI팀"},{"peopleNm":"이종인","peopleNmEn":"","staffRoleNm":"현상팀"},{"peopleNm":"이재헌","peopleNmEn":"","staffRoleNm":"현상팀"},{"peopleNm":"방종갑","peopleNmEn":"","staffRoleNm":"현상팀"},{"peopleNm":"신창호","peopleNmEn":"SHIN Chang-ho","staffRoleNm":"현상팀"},{"peopleNm":"신영호","peopleNmEn":"SHIN Young-ho","staffRoleNm":"현상팀"},{"peopleNm":"신동명","peopleNmEn":"SHIN Dong-myoung","staffRoleNm":"현상팀"},{"peopleNm":"성락군","peopleNmEn":"","staffRoleNm":"현상팀"},{"peopleNm":"최순호","peopleNmEn":"CHOI Soon-ho","staffRoleNm":"현상팀"},{"peopleNm":"이영현","peopleNmEn":"LEE Young-hyun","staffRoleNm":"현상팀"},{"peopleNm":"한충구","peopleNmEn":"HAN Chung-gu","staffRoleNm":"현상팀"},{"peopleNm":"김양래","peopleNmEn":"","staffRoleNm":"현상팀"},{"peopleNm":"장강석","peopleNmEn":"JANG Kang-seok","staffRoleNm":"현상팀"},{"peopleNm":"박선화","peopleNmEn":"PARK Sun-hwa","staffRoleNm":"현상팀"},{"peopleNm":"최창성","peopleNmEn":"CHOI Chang-sung","staffRoleNm":"현상팀"},{"peopleNm":"박남석","peopleNmEn":"PARK Nam-surk","staffRoleNm":"아날로그색보정"},{"peopleNm":"현미나","peopleNmEn":"","staffRoleNm":"홍보/마케팅 진행"},{"peopleNm":"강효미","peopleNmEn":"KANG Hyo-mi","staffRoleNm":"홍보/마케팅 진행"},{"peopleNm":"신보영","peopleNmEn":"","staffRoleNm":"홍보/마케팅 진행"},{"peopleNm":"길창석","peopleNmEn":"","staffRoleNm":"식당차"},{"peopleNm":"이재원","peopleNmEn":"","staffRoleNm":"식당차"},{"peopleNm":"이현승","peopleNmEn":"","staffRoleNm":"식당차"},{"peopleNm":"이수진","peopleNmEn":"","staffRoleNm":"식당차"},{"peopleNm":"신명선","peopleNmEn":"SIN Myung-sun","staffRoleNm":"운송"},{"peopleNm":"이언수","peopleNmEn":"","staffRoleNm":"기타"},{"peopleNm":"정재훈","peopleNmEn":"CHEONG Jai-hoon","staffRoleNm":"시각효과"},{"peopleNm":"백상훈","peopleNmEn":"BAEK Sang-hoon","staffRoleNm":"VFX 슈퍼바이저"},{"peopleNm":"김병래","peopleNmEn":"KIM Byung-rae","staffRoleNm":"VFX 슈퍼바이저"},{"peopleNm":"정재훈","peopleNmEn":"CHEONG Jai-hoon","staffRoleNm":"VFX 슈퍼바이저"},{"peopleNm":"이창희","peopleNmEn":"LEE Chang-hee","staffRoleNm":"VFX 아티스트"},{"peopleNm":"강민정","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"강우경","peopleNmEn":"GANG U-gyeong","staffRoleNm":"VFX 아티스트"},{"peopleNm":"이호성","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"이희원","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"임남수","peopleNmEn":"LIM NAM SU","staffRoleNm":"VFX 아티스트"},{"peopleNm":"임재경","peopleNmEn":"Lim Jae-kyung","staffRoleNm":"VFX 아티스트"},{"peopleNm":"임지호","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"임현정","peopleNmEn":"Lim Hyun Jung","staffRoleNm":"VFX 아티스트"},{"peopleNm":"장정웅","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"장지연","peopleNmEn":"JANG Ji-youn","staffRoleNm":"VFX 아티스트"},{"peopleNm":"정경숙","peopleNmEn":"JEONG KYUNG SUK","staffRoleNm":"VFX 아티스트"},{"peopleNm":"정연찬","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"정우철","peopleNmEn":"JEONG Woo-cheol","staffRoleNm":"VFX 아티스트"},{"peopleNm":"정재화","peopleNmEn":"JUNG Jae Hwa","staffRoleNm":"VFX 아티스트"},{"peopleNm":"정태연","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"정현우","peopleNmEn":"JUNG Hyun-woo","staffRoleNm":"VFX 아티스트"},{"peopleNm":"조상규","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"권영길","peopleNmEn":"Yeong Gil-gwon","staffRoleNm":"VFX 아티스트"},{"peopleNm":"박원봉","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"함유섭","peopleNmEn":"HAM Yu-seop","staffRoleNm":"VFX 아티스트"},{"peopleNm":"홍서연","peopleNmEn":"HONG Seo Yeon","staffRoleNm":"VFX 아티스트"},{"peopleNm":"홍정희","peopleNmEn":"HONG Jung-hee","staffRoleNm":"VFX 아티스트"},{"peopleNm":"이문형","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김영미","peopleNmEn":"KIM Young-mi","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김영아","peopleNmEn":"Kim Young-a","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김용빈","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김용수","peopleNmEn":"KIM Yong-soo","staffRoleNm":"VFX 아티스트"},{"peopleNm":"이상훈","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"이수정","peopleNmEn":"LEE Su-jeong","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김은영","peopleNmEn":"KIM Eun-young","staffRoleNm":"VFX 아티스트"},{"peopleNm":"이윤호","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김정수","peopleNmEn":"KIM Jung-soo","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김정희","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김종성","peopleNmEn":"Kim Jong-sung","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김경문","peopleNmEn":"Kim Kyung-moon","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김교식","peopleNmEn":"KIM Kyo-shik","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김기영","peopleNmEn":"KIM Ki-young","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김대왕","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김동균","peopleNmEn":"KIM Dong-kyun","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김동근","peopleNmEn":"Kim Dong-keun","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김동현","peopleNmEn":"Dong Hyun Kim","staffRoleNm":"VFX 아티스트"},{"peopleNm":"차진영","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"천상기","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김백철","peopleNmEn":"KIM Baek-chol","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김상기","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김성준","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김성철","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김성환","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김세리","peopleNmEn":"","staffRoleNm":"VFX 아티스트"},{"peopleNm":"최지원","peopleNmEn":"CHOI Ji-won","staffRoleNm":"VFX 아티스트"},{"peopleNm":"최진호","peopleNmEn":"CHOI JIN HO","staffRoleNm":"VFX 아티스트"},{"peopleNm":"김수한","peopleNmEn":"Kim Soo-han","staffRoleNm":"VFX 아티스트"},{"peopleNm":"백명기","peopleNmEn":"","staffRoleNm":"VFX 아티스트"}]},"source":"영화진흥위원회"}}
    """.data(using: .utf8)!
    
    static let daumSearchResult = """
    {"documents":[{"collection":"news","datetime":"2019-01-03T15:36:01.000+09:00","display_sitename":"노컷뉴스","doc_url":"http://v.media.daum.net/v/20190103153601107","height":490,"image_url":"https://t1.daumcdn.net/news/201901/03/nocut/20190103153601230nltn.jpg","thumbnail_url":"https://search3.kakaocdn.net/argon/130x130_85_c/2McigDc67YO","width":710},{"collection":"etc","datetime":"2015-12-16T21:09:11.000+09:00","display_sitename":"","doc_url":"http://slownews.kr/20704?replytocom=4503","height":415,"image_url":"http://i0.wp.com/slownews.kr/wp-content/uploads/2014/03/kwanghae.jpg?resize=580%2C415","thumbnail_url":"https://search3.kakaocdn.net/argon/130x130_85_c/CDErUuAJCb6","width":580},{"collection":"blog","datetime":"2023-05-31T22:35:04.000+09:00","display_sitename":"티스토리","doc_url":"https://yujony.com/8","height":441,"image_url":"https://blog.kakaocdn.net/dn/brafb6/btsh59fXlYU/z1d8godsZV28s4p2P49WlK/img.jpg","thumbnail_url":"https://search2.kakaocdn.net/argon/130x130_85_c/7dNjzx2Bss","width":314},{"collection":"blog","datetime":"2012-09-18T15:03:00.000+09:00","display_sitename":"네이버블로그","doc_url":"http://blog.naver.com/lulyone/50150502448","height":148,"image_url":"https://postfiles.pstatic.net/20120918_241/lulyone_13479477190382RiAm_JPEG/naver_com_20120918_115022.jpg?type=w1","thumbnail_url":"https://search1.kakaocdn.net/argon/130x130_85_c/E3PyZl9lAPm","width":240},{"collection":"blog","datetime":"2023-09-15T18:59:04.000+09:00","display_sitename":"티스토리","doc_url":"https://angyengchi.tistory.com/5","height":909,"image_url":"https://blog.kakaocdn.net/dn/cKPGkw/btst6nzC1zM/aGQKeI0ONZlr4U0LJOYfEK/img.png","thumbnail_url":"https://search1.kakaocdn.net/argon/130x130_85_c/JXK4EVqWyAU","width":633},{"collection":"blog","datetime":"2017-10-20T16:36:15.000+09:00","display_sitename":"티스토리","doc_url":"https://blank-in2.tistory.com/7","height":355,"image_url":"https://t1.daumcdn.net/cfile/tistory/99D7113359E988F810","thumbnail_url":"https://search2.kakaocdn.net/argon/130x130_85_c/KqXl81vNPV","width":500},{"collection":"cafe","datetime":"2012-09-09T01:59:02.000+09:00","display_sitename":"Daum카페","doc_url":"https://cafe.daum.net/wkholic-enjoycultur/K5VE/5898","height":592,"image_url":"http://cfile263.uf.daum.net/image/16525A46504B7953078F3B","thumbnail_url":"https://search3.kakaocdn.net/argon/130x130_85_c/6twMSldC51f","width":411},{"collection":"blog","datetime":"2015-03-31T07:51:00.000+09:00","display_sitename":"네이버블로그","doc_url":"http://blog.naver.com/bomin1373/220316127067","height":364,"image_url":"https://postfiles.pstatic.net/20150304_70/leejw0711_1425454458266B70O9_JPEG/1.jpg?type=w2","thumbnail_url":"https://search4.kakaocdn.net/argon/130x130_85_c/8AFSMkI96kT","width":550},{"collection":"blog","datetime":"2024-01-21T14:04:27.000+09:00","display_sitename":"티스토리","doc_url":"https://trend.sonamoo1224.com/27","height":569,"image_url":"https://blog.kakaocdn.net/dn/b0GUS7/btsDJVzD5Qn/4VRheIuXYU1R7QBp4CHUaK/img.jpg","thumbnail_url":"https://search1.kakaocdn.net/argon/130x130_85_c/8edryQxG9qV","width":436},{"collection":"blog","datetime":"2022-05-11T00:00:11.000+09:00","display_sitename":"티스토리","doc_url":"https://gangajinsu2982.tistory.com/17","height":870,"image_url":"https://blog.kakaocdn.net/dn/1DMOa/btrBLFTO5it/3ds1qQ3wiwe00JVifJYox0/img.jpg","thumbnail_url":"https://search4.kakaocdn.net/argon/130x130_85_c/CN88ffE785Y","width":721}],"meta":{"is_end":false,"pageable_count":973,"total_count":998}}
    """.data(using: .utf8)!
}
