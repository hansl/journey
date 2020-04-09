import Array "mo:stdlib/array";
import Types "./types";

type Entry = Types.Entry;
type InternalEntry = Types.InternalEntry;
type User = Types.User;


actor {

    var entries: [InternalEntry] = [];
    var users: [User] = [{
        id = 1;
        name = "Hans Larsen";
        description = "Only user for now.";
    }];
    var uniqueId: Nat = 0;

    public func newEntry(author0: Nat, title0: Text, content0: Text): async Nat {
        uniqueId := uniqueId + 1;
        let entry: InternalEntry = {
            id = uniqueId;
            author = author0;
            content = content0;
            title = title0;
        };
        entries := Array.append<InternalEntry>(entries, [entry]);

        uniqueId
    };

    public func listUsers(): async [User] {
        users
    };

    public query func list(max: Nat): async [Entry] {
        var m = max;
        if (entries.len() == 0) {
            return [];
        };
        if (m > entries.len()) {
            m := entries.len();
        };

        func gen(i: Nat): Entry {
            let e = entries[entries.len() - i - 1];
            func predicate(u: User): Bool {
                u.id == e.author
            };
            let a = Array.find(predicate, users);

            {
                id = e.id;
                author = a;
                title = e.title;
                content = e.content;
            }
        };
        Array.tabulate<Entry>(m, gen)
    };

    public query func get(id0: Nat): async ?Entry {
        func isEq(entry: InternalEntry): Bool {
            entry.id == id0
        };

        switch (Array.find<InternalEntry>(isEq, entries)) {
            case (null) {
                return null;
            };
            case (?e) {
                func predicate(u: User): Bool {
                    u.id == e.author
                };
                let a = Array.find(predicate, users);

                return ?{
                    id = e.id;
                    author = a;
                    title = e.title;
                    content = e.content;
                };
            };
        };
    };

};
