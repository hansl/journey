module {
  public type Entry = {
    // How to identify this entry.
    id: Nat;

    // The person who created the entry.
    author: Text;

    // The content of the entry. In Markdown.
    content: Text;
  };
}
