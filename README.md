# Simple Lottery!
This is a funny ios application that creates a lottery between defined players. It demonestrates how we can achieve clean architecture in an iOS app.

## Intro
"Clean Architecture", This is a word you must have heard it many times so far, in articles, in job descriptions, in books and many places. It's like a magic word that glues the app architecture with clean way to define our units. In this article we try to get down from dozens of high-spectrum concepts to real implementation that we can use in our daily life to have more extensible apps with a proper architecture. 

Let's first talk about the specification of the app we want to demonstrate the clean architecture in it.

## User Story
As a user of the application:
- I can tap on "Start the Lottery" button.
- Then it will show me the loading indicator while the app fetch the data from the web services.
- Then I can see the random name in the lottery list flipping
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

## Clean Architecture
The proposed clean architecture in this article is derived from Uncle Bob's view on the software architecture [1] with modifying points for mobile applications' usability [2].

<img src="https://cdn-images-1.medium.com/max/1200/1*d_HASZfBqk--3efUlOLuQw.png" width="400">

## Repository
Repository is the most underlaying component in the clean architecture. It encapsulates and abstracts the critical logic required for accessing most underlying elements like database, network, third-party libraries and iOS SDK frameworks and shared data and service elements (such as Facade and Service design pattern interfaces). In some articles, they call this layer "Entity" as well.

## Use Case
The bussiness logic of the app is mainly represents in Use Case. It maps the raw data coming from Repository to app domain data structures. It knows how, when and which repositories should combine to construct elements meaningful to the app. All changes in containing repositories should get observed and propagate to upper level component, Presenter.

You may have heard about Interactor in VIPER and RIBs and VIP architecture. It encapsulates the business logic for the specific view or a group of views. This is responsibility that Use Case does in the proposed architecture and refer to the almost same thing.

## Presenter
The main responsibility of Presenter is handling changes occures to the view state. It observes the data changes in underlaying layer, Use Case, and maps it to corresponding view models. In addition, it gets the user action from upstream layer, View, and responds to these user requests. 

An important note is that presenter is UI agnostic. Thus, we shouldn't see any dependency to UI frameworks such as UIKit or SwiftUI in the presenter layer.

## View
All UI components that we use in the app is kept in View layer. They are free from any business logic. They also constructs  in the way that the Presenter, the underlaying layer instructed them to in the view model. Moreover, all user actions in the view should relay to the presenter and the view itself should not decide on any reaction and response in these cases.

## Clean Architecture design of the app
The clean architecture layers of the app has been visualised in the below diagram:
![](https://cdn-images-1.medium.com/max/1600/1*NTpuFdDSgoL-HKVTjX6FuQ.png)

## References
[1] [https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html]()

[2] [https://crosp.net/blog/software-architecture/clean-architecture-part-2-the-clean-architecture/]()
 
## Author
**Soheil Novinfard** - [www.novinfard.com](https://www.novinfard.com)

## License
This project is licensed under the MIT License.
