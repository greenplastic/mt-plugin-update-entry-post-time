# Movable Type plugin for updating entry post time in the entry editing page.
#
# Author:  yosshi <yosshi at gmail.com>
#

package MT::Plugin::UpdateEntryPostTime;
use strict;
use MT;
use base 'MT::Plugin';

my $plugin = MT::Plugin::UpdateEntryPostTime->new({
  name => 'UpdateEntryPostTime',
  description => '',
  doc_link => '',
  version => '1.2',
  author_name => 'yosshi',
  author_link => 'http://profile.typekey.com/yosshi/',
});

MT->add_plugin($plugin);
MT->add_callback('MT::App::CMS::AppTemplateOutput.edit_entry', 10, $plugin, \&_updateentryposttime);
MT->add_callback('MT::App::CMS::template_param.edit_entry', 10, $plugin, \&_updateentryposttime_mt4);

sub _updateentryposttime {
  my ($eh, $app, $output) = @_;
  my $old = qq{<a href="#" onclick="return openManual('entries', 'date')" class="help">?</a>};
  $old = quotemeta($old);
  my $new = qq{<a href="#" onclick="return openManual('entries', 'date')" class="help">?</a>
      <script type="text/javascript">
      function zeropad(num) {
        return (num < 10) ? '0' + num : num;
      }
      function update_authored_on() {
        var now = new Date();
        var y = now.getFullYear();
        var m = zeropad(now.getMonth() + 1);
        var d = zeropad(now.getDate());
        var h = zeropad(now.getHours());
        var min = zeropad(now.getMinutes());
        var s = zeropad(now.getSeconds());
        document.entry_form.created_on_manual.value = y + '-' + m + '-' + d + ' ' + h + ':' + min + ':' + s;
      }
    </script>
    <input type="button" onclick="update_authored_on();" value="Update">};
  
  $$output =~ s/$old/$new/;
  
  return 1;
}

sub _updateentryposttime_mt4 {
  my ($eh, $app, $param, $tmpl) = @_;
  my $node = $tmpl->getElementById('authored_on') or return 1;
  my $html = $node->innerHTML or return 1;
  $html .= <<'HTML';
<script type="text/javascript">
function updateAuthoredOn() {
    var t = new Date();
    document.getElementById('created-on').value = t.toISODateString();
    document.getElementsByName('authored_on_time').item(0).value
        = t.getHours().toString().pad(2, "0") + ':'
        + t.getMinutes().toString().pad(2, "0") + ':'
        + t.getSeconds().toString().pad(2, "0");
}
</script>
<input type="button" onclick="updateAuthoredOn();" value="Update" />
HTML
  $node->innerHTML($html);
  return 1;
}

1;
