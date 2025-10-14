{
  templates = {
    commit_trailers = "format_signed_off_by_trailer(self)\n++ if(!trailers.contains_key(\"Change-Id\"), format_gerrit_change_id_trailer(self))";
  };
}
