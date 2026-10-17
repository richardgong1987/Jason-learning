package demo;

import jason.asSyntax.ASSyntax;
import jason.asSyntax.Structure;
import jason.environment.Environment;

/** Local state simulation, not a physical-device adapter. */
public class DoorEnvironment extends Environment {
    private boolean opened;

    @Override public void init(String[] args) {
        super.init(args);
        addPercept(ASSyntax.createLiteral("door", ASSyntax.createAtom("closed")));
    }

    @Override public synchronized boolean executeAction(String agent, Structure action) {
        if (!action.equals(ASSyntax.createStructure("open", ASSyntax.createAtom("door")))) {
            return false;
        }
        if (!opened) {
            opened = true;
            removePercept(ASSyntax.createLiteral("door", ASSyntax.createAtom("closed")));
            addPercept(ASSyntax.createLiteral("door", ASSyntax.createAtom("open")));
            informAgsEnvironmentChanged();
        }
        return true;
    }
}
