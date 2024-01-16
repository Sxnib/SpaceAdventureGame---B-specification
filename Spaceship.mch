/* Spaceship
 * Author: SuniB
 * Creation date: 06/12/2023
 */
MACHINE
    Spaceship

SEES
    Space

SETS
    MOVEMENT_RESULT = {SUCCESS, FAILED_OUT_OF_BOUNDS, FAILED_ASTEROID_COLLISION, FAILED_INSUFFICIENT_POWER, WARP_SUCCESSFUL, WARP_FAILED_OUT_OF_BOUNDS, WARP_FAILED_ASTEROID_COLLISION, WARP_FAILED_INSUFFICIENT_POWER};
    GAME_STATUS = {GAME_WON, GAME_LOST, GAME_NOT_OVER}

CONSTANTS
    NormalMovePowerConsumption, WarpDrivePowerConsumption, AsteroidCollisionPowerLoss, InitialPower

PROPERTIES
    NormalMovePowerConsumption = 5 &
    WarpDrivePowerConsumption = 20 &
    AsteroidCollisionPowerLoss = 10 &
    InitialPower = 100

VARIABLES
    xPosition, yPosition, power, numberOfAsteroidCollisions, travelRoute, gameStatus

INVARIANT
    xPosition : NATURAL & xPosition : spaceX &
    yPosition : NATURAL & yPosition : spaceY &
    power : NATURAL &
    numberOfAsteroidCollisions : NATURAL &
    travelRoute : seq(NATURAL * NATURAL) &
    gameStatus : GAME_STATUS

INITIALISATION
    xPosition := 1 ||
    yPosition := 1 ||
    power := InitialPower ||
    numberOfAsteroidCollisions := 0 ||
    travelRoute := [1|->1] ||
    gameStatus := GAME_NOT_OVER

OPERATIONS
    result <-- MoveUp =
        PRE
            result : MOVEMENT_RESULT
        THEN
            IF yPosition < max(spaceY) THEN
                IF (xPosition |-> (yPosition + 1)) : asteroids THEN
                    IF power >= AsteroidCollisionPowerLoss THEN
                        power := power - AsteroidCollisionPowerLoss ||
                        numberOfAsteroidCollisions := numberOfAsteroidCollisions + 1 ||
                        result := FAILED_ASTEROID_COLLISION
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                ELSE
                    IF power >= NormalMovePowerConsumption THEN
                        yPosition := yPosition + 1 ||
                        power := power - NormalMovePowerConsumption ||
                        travelRoute := travelRoute <- (xPosition |-> yPosition) ||
                        result := SUCCESS
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                END
            ELSE
                result := FAILED_OUT_OF_BOUNDS
            END
        END;

    result <-- MoveDown =
        PRE
            result : MOVEMENT_RESULT
        THEN
            IF yPosition > min(spaceY) THEN
                IF (xPosition |-> (yPosition - 1)) : asteroids THEN
                    IF power >= AsteroidCollisionPowerLoss THEN
                        power := power - AsteroidCollisionPowerLoss ||
                        numberOfAsteroidCollisions := numberOfAsteroidCollisions + 1 ||
                        result := FAILED_ASTEROID_COLLISION
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                ELSE
                    IF power >= NormalMovePowerConsumption THEN
                        yPosition := yPosition - 1 ||
                        power := power - NormalMovePowerConsumption ||
                        travelRoute := travelRoute <- (xPosition |-> yPosition) ||
                        result := SUCCESS
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                END
            ELSE
                result := FAILED_OUT_OF_BOUNDS
            END
        END;

    result <-- MoveLeft =
        PRE
            result : MOVEMENT_RESULT
        THEN
            IF xPosition > min(spaceX) THEN
                IF ((xPosition - 1) |-> yPosition) : asteroids THEN
                    IF power >= AsteroidCollisionPowerLoss THEN
                        power := power - AsteroidCollisionPowerLoss ||
                        numberOfAsteroidCollisions := numberOfAsteroidCollisions + 1 ||
                        result := FAILED_ASTEROID_COLLISION
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                ELSE
                    IF power >= NormalMovePowerConsumption THEN
                        xPosition := xPosition - 1 ||
                        power := power - NormalMovePowerConsumption ||
                        travelRoute := travelRoute <- (xPosition |-> yPosition) ||
                        result := SUCCESS
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                END
            ELSE
                result := FAILED_OUT_OF_BOUNDS
            END
        END;

    result <-- MoveRight =
        PRE
            result : MOVEMENT_RESULT
        THEN
            IF xPosition < max(spaceX) THEN
                IF ((xPosition + 1) |-> yPosition) : asteroids THEN
                    IF power >= AsteroidCollisionPowerLoss THEN
                        power := power - AsteroidCollisionPowerLoss ||
                        numberOfAsteroidCollisions := numberOfAsteroidCollisions + 1 ||
                        result := FAILED_ASTEROID_COLLISION
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                ELSE
                    IF power >= NormalMovePowerConsumption THEN
                        xPosition := xPosition + 1 ||
                        power := power - NormalMovePowerConsumption ||
                        travelRoute := travelRoute <- (xPosition |-> yPosition) ||
                        result := SUCCESS
                    ELSE
                        result := FAILED_INSUFFICIENT_POWER
                    END
                END
            ELSE
                result := FAILED_OUT_OF_BOUNDS
            END
        END;

    warpResult <-- WarpDrive(newXPosition, newYPosition) =
        PRE
            warpResult : MOVEMENT_RESULT &
            newXPosition : NATURAL & newYPosition : NATURAL
        THEN
            IF newXPosition : spaceX & newYPosition : spaceY THEN
                IF (newXPosition |-> newYPosition) : asteroids THEN
                    warpResult := WARP_FAILED_ASTEROID_COLLISION
                ELSE
                    IF power >= WarpDrivePowerConsumption THEN
                        xPosition := newXPosition ||
                        yPosition := newYPosition ||
                        power := power - WarpDrivePowerConsumption ||
                        travelRoute := travelRoute <- (newXPosition |-> newYPosition) ||
                        warpResult := WARP_SUCCESSFUL
                    ELSE
                        warpResult := WARP_FAILED_INSUFFICIENT_POWER
                    END
                END
            ELSE
                warpResult := WARP_FAILED_OUT_OF_BOUNDS
            END
        END;

    gameCurrentStatus <-- CheckGameStatus =
        PRE
            gameCurrentStatus : GAME_STATUS
        THEN
            IF (xPosition |-> yPosition) = starBase THEN
                gameStatus := GAME_WON ||
                gameCurrentStatus := GAME_WON
            ELSIF power < NormalMovePowerConsumption THEN
                gameStatus := GAME_LOST ||
                gameCurrentStatus := GAME_LOST
            ELSE
                gameCurrentStatus := GAME_NOT_OVER
            END
        END;

    NewGame(initialPower) =
        PRE
            initialPower : NATURAL
        THEN
            xPosition := 1 ||
            yPosition := 1 ||
            power := initialPower ||
            numberOfAsteroidCollisions := 0 ||
            travelRoute := [1|->1] ||
            gameStatus := GAME_NOT_OVER
        END;

    gameStatusResult, currentPosition, currentPower, collisionCount <-- MissionStatus =
        BEGIN
            gameStatusResult := gameStatus ||
            currentPosition := xPosition |-> yPosition ||
            currentPower := power ||
            collisionCount := numberOfAsteroidCollisions
        END;

    route <-- RegionsVisited =
        BEGIN
            route := travelRoute
        END

END
