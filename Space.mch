/* Space
 * Author: SuniB
 * Creation date: 06/12/2023
 */
/* Space
 * Author: Revised by User
 * Creation Date: 06/12/2023
 */
MACHINE
    Space
    
CONSTANTS
    spaceX, spaceY, space, asteroids, emptySpace, homeBase, starBase
    
PROPERTIES
    spaceX = 1..12 &
    spaceY = 1..7 &
    space = spaceX * spaceY &
    
    asteroids <: space &
    asteroids = {3|->2, 3|->5, 5|->4, 6|->7, 7|->1, 7|->5, 7|->7, 8|->3, 10|->6, 11|->2, 12|->5} &
    
    emptySpace <: space &
    emptySpace /\ asteroids = {} &
    emptySpace \/ asteroids = space &
    
    homeBase : emptySpace & homeBase = 1|->1 &
    starBase : emptySpace & starBase = 6|->4
END
