module {
  public type UserRole = {
    #admin;
    #editor;
    #base;
  };

  public type User = {
    id: Principal;
    name: Text;
    role: UserRole;
    description: Text;
  };

  // Externally we return Entry through our API.
  public type Entry = {
    // How to identify this entry.
    id: Nat;

    // The person who created the entry.
    author: ?User;

    // The title of the entry.
    title: Text;

    // The header (first paragraph) of the entry. In Markdown.
    header: Text;

    // The content (which is optional in list).
    content: ?Text;
  };

  // Internally, we store the JOIN key author to the author list.
  public type InternalEntry = {
    // How to identify this entry.
    id: Nat;

    // The person who created the entry.
    author: Principal;

    // The title of the entry.
    title: Text;

    // The content of the entry. In Markdown.
    content: Text;
  };
}
