(define (domain Dungeon)

    (:requirements
        :typing
        :negative-preconditions
    )

    (:types
        swords cells
    )

    (:predicates
        ;Hero's cell location
        (at-hero ?loc - cells)
        
        ;Sword cell location
        (at-sword ?s - swords ?loc - cells)
        
        ;Indicates if a cell location has a monster
        (has-monster ?loc - cells)
        
        ;Indicates if a cell location has a trap
        (has-trap ?loc - cells)
        
        ;Indicates if a cell or sword has been destroyed
        (is-destroyed ?obj)
        
        ;connects cells
        (connected ?from ?to - cells)
        
        ;Hero's hand is free
        (arm-free)
        
        ;Hero's holding a sword
        (holding ?s - swords)
        
    )

    ;Hero can move if the
    ;    - hero is at current location
    ;    - cells are connected, 
    ;    - there is no trap in current loc, and 
    ;    - destination does not have a trap/monster/has-been-destroyed
    ;Effects move the hero, and destroy the original cell. No need to destroy the sword.
    (:action move
        :parameters (?from ?to - cells)
        :precondition (and 
            (at-hero ?from) 
            (connected ?from ?to)
            (not (has-trap ?from))
            (not (is-destroyed ?to))
            (not (has-monster ?to))
            (not (has-trap ?to))             
        )
        :effect (and
            (not (at-hero ?from))
            (at-hero ?to)  
            (is-destroyed ?from)
        )
    )
    
    ;When this action is executed, the hero gets into a location with a trap if
    ;   - hero is at current location
    ;   - cells are connected
    ;   - there is no trap in current loc
    ;   - the place we're going to has a trap
    ;   - the hero's arm is free, and
    ;   - destination has not been destroyed
    (:action move-to-trap
        :parameters (?from ?to - cells)
        :precondition (and 
            (at-hero ?from)
            (connected ?from ?to)
            (not (has-trap ?from))
            (has-trap ?to)
            (arm-free)
            (not (is-destroyed ?to))
        )
        :effect (and
            (not (at-hero ?from)) 
            (at-hero ?to)
            (is-destroyed ?from)
        )
    )

    ;When this action is executed, the hero gets into a location with a monster if
    ;   - hero is at current location
    ;   - cells are connected
    ;   - the hero is holding a sword
    ;   - the destination has a monster
    ;   - there is no trap in current loc
    ;   - destination has not been destroyed
    (:action move-to-monster
        :parameters (?from ?to - cells ?s - swords)
        :precondition (and 
            (at-hero ?from)
            (connected ?from ?to)
            (holding ?s)
            (has-monster ?to)
            (not (has-trap ?from))  
            (not (is-destroyed ?to))      
        )
        :effect (and 
            (not (at-hero ?from))
            (at-hero ?to)
            (is-destroyed ?from)        
        )
    )
    
    ;Hero can pick up a sword if
    ;   - hero is at loc
    ;   - hero's arm is free
    ;   - there is a sword at loc
    (:action pick-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
            (at-hero ?loc)
            (arm-free)
            (at-sword ?s ?loc)
        )
        :effect (and
            (not (arm-free))
            (holding ?s)
        )
    )
    
    ;Hero can destroy his sword if
    ;   - hero is at loc
    ;   - there is no monster at loc
    ;   - there is no trap at loc
    ;   - the hero is holding a sword 
    (:action destroy-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
            (at-hero ?loc)
            (not (has-monster ?loc))
            (not (has-trap ?loc))
            (holding ?s)
        )
        :effect (and
            (arm-free)
            (not (holding ?s))    
        )
    )
    
    ;Hero disarms the trap with his free arm if
    ;   - hero is at loc
    ;   - trap is at loc
    ;   - hero's arm is free
    (:action disarm-trap
        :parameters (?loc - cells)
        :precondition (and 
            (at-hero ?loc)
            (has-trap ?loc)
            (arm-free)
        )
        :effect (and
            (not (has-trap ?loc)) ;The trap has been disarmed, meaning this cell no longer effectively contains a trap.
        )
    )
    
)