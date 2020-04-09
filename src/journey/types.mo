module {
  public type User = {
    id: Nat;
    name: Text;
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

    // The content of the entry. In Markdown.
    content: Text;
  };

  // Internally, we store the JOIN key author to the author list.
  public type InternalEntry = {
    // How to identify this entry.
    id: Nat;

    // The person who created the entry.
    author: Nat;

    // The title of the entry.
    title: Text;

    // The content of the entry. In Markdown.
    content: Text;
  };
}
