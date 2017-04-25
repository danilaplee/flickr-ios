//
//  navComponent.swift
//  flickr-test
//
//  Created by Danila Puzikov on 17/04/2017.
//  Copyright © 2017 Danila Puzikov. All rights reserved.
//

import Foundation
import UIKit
import EasyTipView

class NavComponent: UIViewController, UISearchBarDelegate {
    
    //DEPENDENCY INJECTION
    var app:AppController?
    var mainView:UIViewController?
    
    //VIEWS
    var search:UISearchBar?
    var back_button:UIImageView?
    var fav_button:UIImageView?
    var back_title:UITextView?
    
    // CONSTANTS
    var frame_height = 65;
    let release_timer = 3.0;
    let default_search_text = "Welcome to PetaCat_"
    let background_color = UIColor(red: 198, green: 198, blue: 203)
    let banned_search  = [
        //PORN
        "porn", "erotic", "nude","rape", "suicide", "spam", "narcotic", "weed", "lsd", "horny", "jissom", "homo", " tit ", "tits", "marijuana", "blood", "gore", "claret", "sap", "brutalize", "choke", "molest", "scalp","strangle","poison","anorexia", "bullemia", "womb","raping", "orgies", "fingering","jizz","humping","homosexual","shag","tentacle", "cuddle", "spooning", "boner","breast", "queer","chlamydia","orgy", "syphillis", "gonorrhea", "libido", "erection", "erectile", "rapist", "screw", "handjob", "hand job", "blow job", "pubic", "prostate", "foreplay", "seduce", "lover", "loved", "copulate","virgin", "jissom", "hump", "kiss", "makeout", "aids", "abortion", "std", "stud", "gonorrhea", "hugg", "hugs","bang", "banging", "lust", "condom", "dyke","prudes","hiv","hepatitis","pervert", "ovary", "pregnant","genitalia", "adult", "sex", "порно", "секс", "хуй", "член","анал", "bitch", "cock", "cum", "cunt", " ass ", "assmen", "asses", "gay", "pussy", "dick", "nipple", "intercourse", "fuck", "booty", "whore", "slut", "tinder","facebook", "like to do it", "write me", "my profile", "hooker","creampie","blowjob","cumshot","hentai","interracial","masturbation","milf","shemale","fetish","gangbang","lesbian","squirting","penetration","underwear","69","kamasutra","xxx","bondage","putana","drugs","violence","rated","naked","nudity","flesh","censored","boob","dildo","orgasm","incest","clit","deepthroat","lingerie","weed","chink","cruelty","homicide","prostitute","penis","vagina","infection","quim","fanny","sissy","frigging","busywork","ебля","ебаться","ебат","member","anal","I'am", "I Spend", "Happy Pride","facials","bdsm","fag","intimate","intim","paris","hilton","abuse","scum","scam","liquor","booze","alcohol","beer","buy","sell","instinct",
        //VIOLENCE
        "Acid","Police","National", "Aggressor","Aljazeera","Al-jazeera", "Agitator", "Aim", "Alert", "Ambush", "Ammunition", "Anarchy", "Anguish", "Annihilate", "Apartheid", "Arms", "Arsenal", "Artillery", "Assassin", "Assassinate", "Assault", "Atrocity", "Attack", "Authority", "Barrage", "Barricade", "Battle", "Battlefield", "Belligerent", "Betrayal", "Blast", "Blindside", "Blood", "Bloody", "Bomb", "Bombardment", "Booby trap", "Breach", "Break", "Brutal", "Brutality", "Brute", "Bullet", "Bully", "Burn", "Cadaver", "Camouflage", "Campaign", "Captive", "Capture", "Careen", "Carnage", "Casualties", "Cataclysm", "Causes", "Chaos", "Charge", "Charred", "Checking", "Clandestine", "Clash", "Coalition", "Collapse", "Combat", "Commandos", "Concentration", "Concussion", "Conflagration", "Conflict", "Confrontation", "Conquer", "Consequences", "Consolidate", "Conspiracy", "Conspire", "Control", "Coordinates", "Corpse", "Counterattack", "Countermand", "Crash", "Crime", "Crisis", "Cross-hairs", "Culpability",	"Damage", "Danger", "Dangerous", "Dash", "Dead", "Deadly", "Death", "Debacle", "Deception", "Deliberate", "Demolish", "Demoralize", "Despot", "Destroy", "Destruction", "Devastation", "Dictator", "Dictatorship", "Die", "Disarmament", "Disaster", "Disastrous", "Discipline", "Disease", "Dispute", "Disruption", "Division", "Domination", "Doom", "Downfall", "Drama", "Dread", "Encounter", "Enemy", "Enforce", "Engagement", "Epithet", "Escalate", "Excess", "Execute", "Execution", "Expectations", "Explode", "Exploitation", "Explosion", "Explosive", "Expunge","fox news", "foxnews", "Extremism", "Faction", "Fanatic", "Fatal", "Fear", "Fearful", "Felon", "Ferment", "Ferocious", "Feud", "Fierce", "Fiery", "Fight", "Fighter", "Force", "Forceful", "Forces", "Fray", "Frenzy", "Front lines", "Fuel", "Fugitive", "Furtive","Gang", "Gang up on", "Gas", "Genocide", "Germ warfare", "Grave", "Grenade", "Grievous", "Groans", "Guard", "Guerrillas", "Guided bombs", "Gun", "Gunship","Hammering", "Harass", "Harsh", "Hatch", "Hate", "Hatred", "Hazard", "Hiding", "Hijack", "Hijacker", "Hit", "Hit-and-run", "Holocaust", "Horror", "Hostility", "Howitzer", "Hurt","Ignite", "Impact", "Incident", "Incite", "Incontrovertible", "Infanticide", "Infiltrate", "Inflame", "Informant", "Injuries", "Inmate", "Insurgent", "Insurrection", "Intense", "Intercept", "Interdiction", "Interrogation", "Intervene", "Intimidate", "Invasion", "Investigate", "Investigations", "Involvement", "Ire", "Jail", "Jeer", "Jets","Jihad","Kamikaze", "Keen", "Kidnap", "Killing", "Knife", "Knock-out", "Laser-activated", "Launch", "Launcher", "Loathsome","Maim", "Malevolent", "Malicious", "Maraud", "March", "Massacre", "Mayhem", "Megalomania", "Menace", "Militancy", "Militant", "Militaristic", "Military", "Militia", "Mines", "Missile", "Mission", "Mistreatment", "Mob", "Mobile", "Mobilization", "Momentum", "Mortars", "Munitions", "Murder", "Muscle","Nationalist", "Neutralize", "Nightmare", "Nitrate", "Notorious","Offensive", "Officials", "Onerous", "Operation", "Opposition", "Order", "Out of control", "Outbreak", "Overrun", "Overthrow","Pacify", "Partisan", "Patrol", "Penetrate", "Perform", "Persecute", "Petrify", "Photos", "Pilot", "Pistol", "Planes", "Plunder", "Position", "Post-traumatic", "Potent", "Pound", "Powder", "Power", "Powerful", "Preemptive", "Premeditate", "Prey", "Prison", "Prisoner", "Proliferation", "Provocation", "Prowl", "Pugnacious", "Pulverize", "Pushing","Quail", "Quarrel", "Quell", "Quiver","Radiation", "Radical", "Rage", "Ravage", "Ravish", "Rebel", "Rebellion", "Reconnaissance", "Recovery", "Recruit", "Refugee", "Regime", "Regiment", "Reinforcements", "Relentless", "Reparation", "Reprisal", "Reputation", "Resistance", "Retaliation", "Retreat", "Retribution", "Revenge", "Revolution", "Ricochet", "Rifle", "Rift", "Riot", "Rival", "Rocket", "Rot", "Rounds", "Rule", "Ruthless","Sabotage", "Sacrifice", "Salvage", "Sanction", "Savage", "Scare", "Scramble", "Secrecy", "Sedition", "Seize", "Seizure", "Sensor", "Setback", "Shelling", "Shells", "Shock", "Shoot", "Shot", "Showdown", "Siege", "Skirmish", "Slaughter", "Smash", "Smuggle", "Soldier", "Special-ops", "Specialized", "Spy", "Squad", "Stalk", "Stash", "Stealth", "Storm", "Straggler", "Strangle", "Strategic", "Strategist", "Strategy", "Strength", "Strife", "Strike", "Strip", "Stronghold", "Struggle", "Subversive", "Suffering", "Superstition", "Suppression", "Surrender", "Survival", "Survivor", "Suspect","Tactics", "Tank", "Target", "Tension", "Terror", "Terrorism", "Terrorist", "Terrorize", "Threaten", "Thug", "Thwart", "Topple", "Torch", "Tornado", "Torpedo", "Tourniquet", "Tragic", "Training", "Trample", "Trap", "Trauma", "Treachery", "Trench", "Trigger", "Triumph", "Tsunami", "Turbulent", "Unconventional", "Unleash", "Unruly", "Uprising","Vagrant", "Vanguard", "Vanish", "Vehicular", "Vendetta", "Venomous", "Vicious", "Victory", "Vile", "Vilify", "Violation", "Violence", "Virulence", "Vital", "Vitriol", "Vociferous", "Void", "Vow", "Vulnerability","Wage", "War", "Warheads", "Warplane", "Warrant", "Warrior", "Watchdog", "Watchful", "Weapon", "Well-trained", "Wound", "Wreckage","Yearn","Yelling","Zeal", "Zealot", "Zigzag", "Zone"
    ]
    
    //GENERAL PARAMS
    var screen_bounds:CGRect?
    var frame_portrait:CGRect?
    var frame_horizontal:CGRect?
    var search_frame:CGRect?
    
    //DYNAMIC PARAMS
    var prev_search:String = ""
    
    
    //UI SERVICES
    var release_service:Timer?
    
    func calcViewFrames() {
        let w_int = Int(screen_bounds!.width)
        let h_int = Int(screen_bounds!.height)
        let offset_y = 20
        
        frame_portrait = CGRect(x:0,y:0,width:w_int, height:frame_height)
        frame_horizontal = CGRect(x:0,y:0,width:h_int, height:frame_height)
        
        //SEARCH FRAME
        var s_offset_x  = 0
        var s_width     = w_int
        
        if(back_button?.isHidden == false) {
            s_offset_x = Int(back_button!.frame.width);
            s_width = w_int - s_offset_x;
        }
        if(fav_button?.isHidden == false) {
            s_width = s_width - Int(fav_button!.frame.width)
        }
        
        search_frame = CGRect(x:s_offset_x, y:offset_y, width:s_width, height:frame_height-offset_y)
    }
    
    init(v:UIViewController, a:AppController)
    {
        
        super.init(nibName: nil, bundle: nil)
        
        //DEPENDENCY INJECTION
        app = a;
        mainView = v
        frame_height = a.nav_height;
        
        //INITIALIZE GENERAL PARAMS
        screen_bounds = UIScreen.main.bounds
        calcViewFrames()
        
        //INIT VIEWS
        
            //MAIN VIEW
            view.frame = frame_portrait!;
            view.backgroundColor = background_color;
        
            //ADDITIONAL VIEWS
        
                //SEARCH BAR
                search = UISearchBar(frame: search_frame!)
                search?.placeholder = default_search_text;
                search?.isUserInteractionEnabled = true;
                search?.barStyle = .default
                search?.delegate = self;
                view.addSubview(search!)
        
            //
        
        //END VIEWS
        
        print("INITIALIAZED NAV")
        print("TOTAL BANNED WORDS "+banned_search.count.description)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NAV DID LOAD")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //SEARCH
    
    func startSearch(){
        var text = " "+search!.text!.lowercased()+" "
        for q in banned_search {
            text = text.replace(q.lowercased(), "")
        }
        if(text.replace(" ", "").characters.count == 0
            || text == ""
            || prev_search == text) {
            dismissKeyboard()
            return
        }
        text.remove(at: text.startIndex)
        search?.text = text
        prev_search = text;
        app!.current_page = 1;
        app!.searchFullText(text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dismissKeyboard()
        startSearch()
        search?.showsCancelButton = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        startSearch()
    }
    func dismissKeyboard() {
        DispatchQueue.main.async(execute: {
            self.view.endEditing(true)
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel button clicked")
        dismissKeyboard()
        self.search!.text = ""
        self.app!.cleanState()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        app?.view?.dismissTips(done: { (s) in
            self.search?.showsCancelButton = true;
        })
//        DispatchQueue.main.async(execute: {
//            self.release_service?.invalidate()
//            self.release_service = Timer.scheduledTimer(timeInterval: self.release_timer, target: self, selector:#selector(self.startSearch), userInfo: nil, repeats: true)
//        });
    }
    
    //END SEARCH
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
