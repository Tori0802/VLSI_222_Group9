*University of Science and Technology - Vietnam National University, Ho Chi Minh City*

*Học kì 222 - Năm học 2022-2023*
# LSI Logic Design - Bound Flasher
<ul>
<li>Giảng viên lí thuyết : PGS.TS Trần Ngọc Thịnh </li>
<li>Giảng viên thí nghiệm : Huỳnh Phúc Nghị </li>
</ul>

<br> 

## Sinh viên thực hiện
| Name | ID |
| :---- | :----: |
| Bùi Thanh Duy | 1912871 |
| Vũ Quang Huy | 1913578 |
| Lê Duy Hào | 2011142 |
| Đỗ Thành Minh | 2011610 |
| Nguyễn Ngọc Trí | 2012286 |

<br> 


## Interface
![Cap1](https://user-images.githubusercontent.com/109940367/226401390-d0b057ca-4817-4835-bd1a-d28cda58dd6c.PNG)
<br>
| Signal | Width | In/Out | Description |
| :----: | :----: | :----: | :---- |
| clk | 1 | In | Tín hiệu clock, kích cạnh dương |
| rst_n | 1 | In | Tín hiệu reset, tích cực mức thấp |
| flick | 1 | In | Tín hiệu đặc biệt để điều khiển trạng thái |
| led[15..0] | 16 | Out | Output led[15..0] có 16 đèn |

<br> 

## Block Diagram
![Biểu đồ không có tiêu đề drawio (2)](https://user-images.githubusercontent.com/109940367/226403206-5b7da4db-26ef-42c5-918d-b087084412a1.png)
<br>
| Name | Type | Description | 
| :----: | :----: | :---- |
| rst_n | input | Tín hiệu reset |
| clk | input | Xung clock |
| flick | input | Tín hiệu đặc biệt |
| led[15..0] | output | Trạng thái đèn |
| current_state | reg | Chứa thông tin của trạng thái hiện tại |
| next_state | reg | Chứa thông tin của trạng thái tiếp theo |
| count | integer | Dùng để bật tắt đèn, quyết định đến trạng thái tiếp theo |
| led_operation | reg | Điều khiển count trong xung nhịp tiếp theo |
| Change state | DFF | Thay đổi trạng thái hiện tại đến trạng thái kế |
| Decoder | decoder block | Chuyển đổi tín hiệu count thành đèn LED |
| Operation on Count | DFF | Xác định việc tăng, giảm tín hiệu count dựa trên đầu vào |
| Logic | control block | Xử lí các điều kiện và chuyển tín hiệu xuống khối Operation on count |
| FSM | control block | Xác định trạng thái tiếp theo |
<br> 


## Finite State Machine
![Cap2](https://user-images.githubusercontent.com/109940367/226404803-d0a607de-3239-40b1-8e19-fb908d19bceb.PNG)
| State name | Description |
| :----: | :---- |
| INIT | Đây là trạng thái đầu tiên của FSM, dùng để làm mới toàn bộ các trạng thái của 16 led đơn về mức “0”, bất kể 16 led đơn đang ở trạng thái nào đi nữa: <br /> Led[count] = 0 <br /> count-- <br />Kiểm tra điều kiện: <br /> + Nếu count < 0 và flick == 1: nhận tín hiệu flick để bắt đầu sáng dần về Led[5] (chuyển sang state “ON 0 TO 5”). <br /> + Nếu count >= 0: state init đóng vai trò tắt dần dần 16 led nếu state trước đó là “ON_5_TO_15” (ở lại state INIT). |
| ON 0 TO 5 | Đây là trạng thái các led đơn từ vị trí 0 tới 5 của mảng 16 led (LED[0] tới LED[5]) được bật sáng dần dần qua từng chu kỳ xung clock: <br /> Led[count] = 1 <br /> count++ <br /> Kiểm tra điều kiện: <br /> + Nếu count == 5: sáng đủ đến Led[5], chuyển sang tắt dần về Led[0] (chuyển sang state “OFF_TO_0”). <br /> + Nếu count < 5: sáng chưa đủ đến Led[5], tiếp tục bật sáng dần (ở lại state “ON_0_TO_5”). |
| OFF TO 0 | Trạng thái có chức năng thực hiện hiệu ứng tắt dần dần các đèn ở vị trí count đến 0 theo chu kì xung clock bằng việc thực hiện tắt đèn mỗi ở vị trí count: <br /> Led[count] = 0 <br /> count-- <br /> Kiểm tra điều kiện: <br /> + Nếu count >= 0, quay lại trạng thái OFF_TO_0 <br /> + Nếu count < 0, chuyển sang trạng thái ON_0_TO_10 |
| ON 0 TO 10 | Trạng thái có chức năng thực hiện hiệu ứng bật đèn dần dần các đèn ở vị trí 0 đến 10 theo chu kì xung clock bằng việc thực hiện bật đèn ở mỗi vị trí count: <br /> count++ <br /> Led[count] = 1 <br /> Kiểm tra điều kiện: <br /> + Nếu count < 10 và count không phải là Kickback point hoặc plick = 0, quay lại trạng thái ON_0_TO_10 <br />+ Nếu count là Kickback point và flick = 1, chuyển về lại trạng thái OFF_TO_ 0 <br /> + Nếu count = 10 và flick = 0, chuyển sang trạng thái OFF_TO_5 |
| OFF TO 5 | Điều kiện so sánh trước khi vào trạng thái này sẽ có hai trường hợp: <br /> - count == 10 && flick == 0 (từ trạng thái ON_0_TO_10 chuyển sang) <br /> - (count == 5 hoặc count == 10) && flick == 1 (từ trạng thái ON_5_TO_15 chuyển sang) <br /> Trạng thái này sẽ lần lượt tắt từ LED[count] cho đến đèn LED[5], tắt mỗi đèn trong một chu kì xung clock: <br /> - LED[count] = 0: tắt đèn thứ count <br /> - count— : giảm giá trị biến count để có thể tắt đèn tiếp theo nếu có) <br /> Chỉ đến khi nào count < 5 (tức là đã tắt xong đèn LED[5]) thì mới chuyển sang trạng thái tiếp theo ON_5_TO_15. |
| ON 5 TO 15 | Điều kiện so sánh trước khi vào trạng thái này sẽ là count < 5. <br />Trạng thái này sẽ tiến hành bật lần lượt từ đèn LED[5] đến đèn LED[15], bật mỗi đèn trong một chu kì xung clock: <br /> - count++ : tăng giá trị biến count <br /> - LED[count] = 0: bật đèn thứ count <br /> Trong quá trình bật đèn nếu ở các điểm kickpoint mà biến flick được kích giá trị bằng 1 thì ngay lập tức dừng lại và chuyển sang trạng thái OFF_TO_5. <br /> Cuối cùng, nếu đã hoàn thành bật đến LED[15] thì sẽ tiến hành chuyển sang trạng thái INIT để reset lại các đèn. |

