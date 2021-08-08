# Simple Lottery!
This is a funny ios application that creates a lottery between defined players. It demonestrates how we can achieve clean architecture in an iOS app.

## Intro
"Clean Architecture", This is a word you must have heard it many times so far, in articles, in job descriptions, in books and many places. It's like a magic word that glues the app architecture with clean way to define our units. In this article we try to get down from dozens of high-spectrum concepts to real implementation that we can use in our daily life to have more extensible apps with a proper architecture. 

Let's first talk about the specification of the app we want to demonstrate the clean architecture in it.

## User Story
As a user of the application I can tap on "Start the Lottery" button.
- So I can see the name in the lottery list flipping
- After 10 rounds the screen stops and draw the last name candidate for winning the lottery.
- Unless the user is not "void" the drawn name is the winner. If the user is "void" the lottery doesn't have any winner!

## API
The data used for this application comes from two different endpoints.

### User Endpoint
The user list can be fetched via the Users API:
http://novinfard.com/API/SimpleLottery/users.json
```
{
  "items": [
    {
      "userId": 10,
      "name": "Jack Alexy",
      "username": "JAlex",
      "regDate": "2020-10-19"
    },
    {
      "userId": 22,
      "name": "Mr. Hashemi",
      "username": "Hashaaa",
      "regDate": "2019-08-19"
    },
    {
      "userId": 4,
      "name": "Mack",
      "username": "mackMack13",
      "regDate": "2018-10-02"
    },
    {
      "userId": 18,
      "name": "Pack",
      "username": "packPackDom",
      "regDate": "2018-04-12"
    },
    {
      "userId": 182,
      "name": "Mohsen",
      "username": "AghaMohsen",
      "regDate": "2020-04-12"
    }
  ]
}
```

It contains user id, full name, username and registration date of the user.

### Lottery List Endpoint
The other endpoint gives us the list of user ids who have been participated in the lottery:
http://novinfard.com/API/SimpleLottery/usersInLottery.json
```
{
  "lotteryList": [
    {
      "userId": 10,
      "void": false
    },
    {
      "userId": 22,
      "void": false
    },
    {
      "userId": 4,
      "void": false
    },
    {
      "userId": 182,
      "void": true
    }
  ]
}
```
The void is a boolean indicator for "void" users, if the name drawn for them, the lottery has no winner.

## Application Flow
The flow of the app demonstrated in the following diagram:
![](https://cdn-images-1.medium.com/max/1600/1*3xm0hZ-WgbA702Owod2D-A.png)

As you can see user first the landing view (1) and by pressing the button the game starts. It firstly displays the loading view (2) when it tries to fetch the data from the two mentioned APIs and merge it into a list of lottery player data that the app expects to handle. In the next stage, a name of the player in the lottery appears on screen randomly in 10 rounds (3). Finally the last name will be drawn as the winner of the lottery, if the choice is not a void one (4).

## Author
**Soheil Novinfard** - [www.novinfard.com](https://www.novinfard.com)

## License
This project is licensed under the MIT License.
