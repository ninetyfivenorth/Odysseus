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
/* Communicates that the connection to a page is secure, and
    (TODO) the certification for such. */
namespace Odysseus.Traits {
    public void report_https(Gee.List<StatusIndicator> indicators, WebKit.WebView web) {
        TlsCertificate cert;
        TlsCertificateFlags errors;

        if (!web.get_tls_info(out cert, out errors)) return;

        var msg = _("Your connection to %s is secure from eavesdroppers,") + "\n";
        msg += _("Your activity can be seen by the admins and hosting companies for this site.");
        StatusIndicator status;
        if (errors == 0)
            status = new StatusIndicator("security-high", Status.SECURE,
                    msg.printf(new Soup.URI(web.uri).host)
                );
        else status = new StatusIndicator("security-low", Status.ERROR,
                // FIXME provide more information about the error.
                _("Certificate validation failed! This site may be an imposter.")
            );

        if (TlsCertificateFlags.UNKNOWN_CA in errors)
            status.bullet_point(_("Unknown certificate authority"));
        if (TlsCertificateFlags.BAD_IDENTITY in errors)
            status.bullet_point(_("Wrong site named in certificate"));
        if (TlsCertificateFlags.NOT_ACTIVATED in errors)
            status.bullet_point(_("Not yet active certificate"));
        if (TlsCertificateFlags.EXPIRED in errors)
            status.bullet_point(_("Expired certificate"));
        if (TlsCertificateFlags.REVOKED in errors)
            status.bullet_point(_("Known bad certificate"));
        if (TlsCertificateFlags.INSECURE in errors)
            status.bullet_point(_("Broken encryption scheme."));
        if (TlsCertificateFlags.GENERIC_ERROR in errors)
            status.bullet_point(_("Unknown error…"));

        indicators.add(status);
    }
}
