/**
* This file is part of Odysseus Web Browser (Copyright Adrian Cochrane 2018).
*
* Odysseus is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Odysseus is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with Odysseus.  If not, see <http://www.gnu.org/licenses/>.
*/
/** Indicates local resources as being "super-secure" */
namespace Odysseus.Traits {
    public void report_local(Gee.List<StatusIndicator> indicators, WebKit.WebView web) {
        var local_prefixes = ("odysseus source icon about " + 
                "https://127.0.0.1 http://127.0.0.1 https://localhost http://localhost"
            ).split(" ");
        var is_local = false;
        foreach (var prefix in local_prefixes) {
            var uri = web.uri;
            is_local = uri.has_prefix(prefix + ":") || uri.has_prefix(prefix + "/");
            if (is_local) break;
        }
        if (!is_local) return;

        indicators.add(new StatusIndicator("view-private computer", Status.SECURE,
            _("This page was loaded from your computer. Noone else knows you're here.")
        ));
    }
}
