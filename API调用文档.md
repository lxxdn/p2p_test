# README

## API 接口

### 创建用户

Action: POST
Url: /api/users

Parameters:

1. password
2. balance (可选，默认值为0)

Example:

```sh
curl -i "https://myp2ptest.herokuapp.com/api/users" -d "password=1234&balance=100"
```

返回值:  user_id 和 access_token

### 登陆获得 access_token

这个api不是必要的

Action: POST
Url: /api/login

Parameters:

1. password
2. balance (可选，默认值为0)

Example:

```sh
curl -i "https://myp2ptest.herokuapp.com/api/login" -d "id=15&password=1234"
```
返回值 access_token


### 创建一笔借款

Action: POST
Url: /api/lend

Parameters

1. source_id 借出钱的用户id
2. target_id 借入钱的用户id

Headers: X-API-Token  借出钱用户的access_token


Example:

id为12的用户借给user为13的用户30元钱

```sh
curl -i -H 'X-API-Token: j34ck1zql2' "https://myp2ptest.herokuapp.com/api/lend" -d "source_id=12&target_id=13&amount=30"
```

返回值

如果成功，返回204 no\_content

### 创建一笔还款

Action: POST
Url: /api/payback

Parameters:

1. source_id 还出钱的用户id
2. target_id 收到钱的用户id

Headers: X-API-Token  还出钱用户的access_token

Example:

id为13的用户还给user为12的用户30元钱

```sh
curl -i -H 'X-API-Token: fbxplll6sg' "https://myp2ptest.herokuapp.com/api/payback" -d "source_id=13&target_id=12&amount=30"
```

返回值

如果成功，返回204 no\_content

### 查询用户账户情况

Action: GET
Url: /api/check_for

Parameters:

1. user_id 查询用户的id

Headers: X-API-Token 用户的access_token

Example:

查询id为12的用户的账户情况

```sh
curl -i -H 'X-API-Token: fbxplll6sg' "https://myp2ptest.herokuapp.com/api/check_for?user_id=12"
```

返回值

balance  余额
amount_of_lend 借出总额
amount_of_borrow 借入总额

### 查询两个用户的债务情况

Action: GET
Url: /api/check_between

Parameters:

1. user_id 主用户，需要提供access_token
2. user2_id 比较用户

Headers: X-API-Token 用户的access_token

Example:

查询id为12的用户和id为13的用户的债务情况

```sh
curl -i -H 'X-API-Token: j34ck1zql2' "https://myp2ptest.herokuapp.com/api/check_between?user_id=12&user2_id=13"
```

返回值

debt
如果是正数，表示id为12的用户借钱给id为13的用户
如果是负数，表示id为12的用户欠id为13的用户
如果是零，表示没有债务关系
