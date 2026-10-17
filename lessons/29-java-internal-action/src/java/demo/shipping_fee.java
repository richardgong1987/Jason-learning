package demo;

import jason.JasonException;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.NumberTermImpl;
import jason.asSyntax.Term;

/** A small pure computation: no network calls or external side effects. */
public class shipping_fee extends DefaultInternalAction {
    @Override public int getMinArgs() { return 2; }
    @Override public int getMaxArgs() { return 2; }

    @Override public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        checkArguments(args);
        if (!(args[0] instanceof NumberTerm)) {
            throw new JasonException("Weight must be a number");
        }
        double weight = ((NumberTerm) args[0]).solve();
        if (!Double.isFinite(weight) || weight < 0) {
            throw new JasonException("Weight must be finite and nonnegative");
        }
        return un.unifies(args[1], new NumberTermImpl(2 + 2 * weight));
    }
}
