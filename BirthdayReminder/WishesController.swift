import UIKit

class WishesController: UITableViewController {
    
    var wishes = [
        "May your birthday be sprinkled with fun and laughter. Have a great day!",
        "Warmest wishes for a very happy birthday.",
        "Congratulations on your birthday! Wishing you a truly fabulous day.",
        "Wishing you a very special birthday and a wonderful year ahead!",
        "I hope your birthday is full of sunshine and rainbows and love and laughter! Sending many good wishes to you on your special day.",
        "Happy Birthday! I hope you have a great day today and the year ahead is full of many blessings.",
        "Wishing you a very happy birthday! May all your dreams come true.",
        "Happy Birthday! I hope you have a wonderful day and that the year ahead is full of fun and adventure.",
        "Happy Birthday! Wishing you a beautiful day and many blessings for the year ahead.",
        "Congratulations on your birthday! Sending you our love and good wishes.",
        "Many happy returns to you on your birthday! We hope you have a wonderful day full of friends, family, and cake!",
        "Happy Birthday to a great buddy! I hope you have a good one.",
        "Happy Birthday! There’s no one else I’d rather be quarantined with.",
        "Happy Birthday! Sit back, relax, and celebrate how truly wonderful you are with a well-deserved quarantini!",
        "Today I’ll be singing happy birthday to you twice every time I wash my hands and sending lots of birthday love your way. Have a good one!",
        "I can’t wait to be less than 6 feet away from you! Happy birthday!",
        "On the bright side, at least you don’t have to share your birthday cake with anyone else this year!",
        "Wishing you a very happy birthday from a safe and appropriate social-distance!",
        "Keep Calm and Stay Safe... and have a very Happy Birthday!",
        "So very sorry to hear you’re not well on your birthday. Sending lots of love and happiness your way!",
        "Sending lots of love and a big virus-free hug on your birthday. I miss you enormously and I can’t wait to take you out to party properly once lockdown is over!",
        "I wanted to get you something truly amazing and inspiring for your birthday and then I remembered that you already have me.",
        "Happy Birthday! Don’t forget to iron that birthday suit.",
        "Those aren’t gray hairs you see. They’re strands of birthday glitter growing out of your head.",
        "Don’t let aging get you down. It’s too hard to get up again!",
        "You’re [insert age]? Better take that cake outdoors to light the candles! Have a very happy birthday.",
        "[insert age] is a perfect age. You’re old enough to recognize your mistakes but young enough to make some more. Happy Birthday!",
        "Don’t worry, they are not gray hairs, they are wisdom highlights. You just happen to be extremely wise.",
        "Night sweats and hot flashes are nature’s way of lowering your heating bill so you can save more money for your retirement.",
        "Happy Birthday! I’m so pleased to hear you’re over the hill instead of under it.",
        "Happy Birthday. It took you [insert age] years to look this good!",
        "I wouldn’t say you’re old... you’ve just been young for longer than most of us. Happy Birthday!",
        "You’re not getting older... just more distinguished! Happy Birthday.",
        "By the time you’re [insert age] you’ve learned everything - you only have to remember it! Many happy returns on your birthday.",
        "You know you’re getting older when an “all-nighter” means not getting up to pee.",
        "Middle age: that time when you finally get your head together - then your body starts falling apart.",
        "Middle age is when your age starts to show around your middle.",
        "Middle age... when “happy hour” is a nap!",
        "How do you know you’ve hit middle-age? In preparation for a big sneeze you cross your legs really hard and hope for the best!",
        "You are so old, you walked into an antique shop and they sold you.",
        "You know you’re getting old when you can’t walk past a bathroom without thinking, “I may as well pee while I’m here.",
        "You know you’re old when you turn down the lights to be economical instead of romantic.",
        "A little gray hair is a small price to pay for so much wisdom.",
        "You know you’re getting old when the little old gray-haired lady you helped across the street is your wife.",
        "If gray hair is a sign of wisdom, then you’re a genius!",
        "A wise man once said, “Forget about your past, you cannot change it”. I’d like to add: “Forget about your present, I didn’t get you one”.",
        "I spent 3 hours searching the internet for the perfect birthday message for you and then I gave up. Happy Birthday."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Wishes", for: indexPath)

        let wish = wishes[indexPath.row]
        cell.textLabel?.text = wish

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var alertStyle = UIAlertController.Style.actionSheet
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
          alertStyle = UIAlertController.Style.alert
        }

        let ac = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        
        let action = UIAlertAction(title: "Copy", style: .default, handler: { (action) in
            let cell = tableView.cellForRow(at: indexPath)
            UIPasteboard.general.string = cell?.textLabel?.text
        }
        )
        ac.addAction(action)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    


}
