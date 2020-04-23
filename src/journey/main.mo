import Array "mo:stdlib/array";
import Types "./types";

type Entry = Types.Entry;
type InternalEntry = Types.InternalEntry;
type User = Types.User;


actor {

    var admin: ?Principal = null;

    var entries: [InternalEntry] = [];
    // TODO: Change this to a hash map.
    var users: [User] = [];
    var uniqueId: Nat = 0;

    func getUser(id: Principal): ?User {
        func predicate(u: User): Bool {
            u.id == id
        };
        Array.find(predicate, users)
    };

    func isAdmin(id: Principal): Bool {
        switch (admin) {
            case (null) {
                return false;
            };
            case (?p) {
                return p == id;
            }
        }
    };

    public shared(msg) func setAdmin(): async () {
        switch (admin) {
            case (null) {
                admin := ?msg.caller;
            };
            case (?e) {};
        }
    };

    public shared(msg) func setUserRole(id: Principal): async () {
        if (isAdmin(msg.caller)) {
            let u = getUser(id);
            switch (u) {
                case (null) {};
                case (?u) {
                    let newUser = {
                        id = u.id;
                        name = u.name;
                        description = u.description;
                        editor = true;
                    };
                    func predicate(c: User): Bool {
                        c.id != u.id
                    };
                    users := Array.append<User>(Array.filter<User>(predicate, users), [newUser]);
                };
            }
        }
    };

    public shared(msg) func createUser(name0: Text, desc0: Text): async () {
        let user: User = {
            id = msg.caller;
            editor = false;
            name = name0;
            description = desc0;
        };
        users := Array.append<User>(users, [user]);
    };

    public shared(msg) func getUserList(): async [User] {
        if (isAdmin(msg.caller)) {
            return users;
        } else {
            return [];
        }
    };


    public shared(msg) func newEntry(title0: Text, content0: Text): async Nat {
        let u = getUser(msg.caller);
        switch (u) {
            case (null) {
                return 0;
            };
            case (?u) {
                if (u.editor == false) {
                    return 0;
                }
            }
        };

        uniqueId := uniqueId + 1;
        let entry: InternalEntry = {
            id = uniqueId;
            author = msg.caller;
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
            let a = getUser(e.author);

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
