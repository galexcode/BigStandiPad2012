
BigStand 2012
=======

BigStand is an Offline Music Browser for performers of all kinds. Load your lyrics, chords, cheatsheets and sheet music into your iPad when you are offline, organize into convenient Set Lists, and use BigStand in performance, with or without Internet.

BigStand is based on the previous app GigStand which was in the App Store a while back. Several features have been removed to simplify the user interface for typical users.


To Customize Your BigStand
-----------

If you have some content that you want to "share" amongst your band or choir you have a few choices:

*Get the current version from the App Store, add single tunes and .zip files iTunes file sharing and email
*Take the source code from here and build in your own .zip files in the /samples directory. 

Features that are different
----------------------

Various UI modes have been eliminated.  One finger access is possible for all functions needed during performance. 

The metronome and autoscroller are disabled in this release, but all the code is workable.

> Just add the buttons wherever you'd like them (normally in the bottom center toolbar)
> The long press gesture recognizer should be re-enabled in order to get to the respective control panels for these tools

Triple tap to enter or leave full screen mode regardless of whether the fullscreen button is shown

When started, BigStand attempts to display the most recent item added to the "Recents" list.




File Types That Open in BigStand
-------------
Many IOS Apps support opening a file in another app -most importantly Mail and Gmail. Here's what BigStand does...
			
				<table>
					<tr ><th >Type</th><th>Stored As</th><th>Displayed As</th>
					</tr><tr>
					<td> HTML		</td><td> As received with supplied Tune Title.	</td><td> displays in pdf viewer in     webview						</td></tr><tr>
					<td> PDF</td><td> 		As received with supplied Tune Title.	</td><td> displays in pdf viewer in     webview
							</td></tr><tr>
					<td> DOC	</td><td> 	As received with supplied Tune Title.</td><td> 	displayed as is in     webview, autoscroll
								</td></tr><tr>
					<td> RTF		</td><td> As received with supplied Tune Title.	</td><td> displayed as is in     webview, autoscroll
									</td></tr><tr>
					<td> TXT		</td><td> As received with supplied Tune Title.	</td><td>  wrapped, rewritten into HTML,displays in     webview
										</td></tr><tr>
					<td> PNG		</td><td> As received with supplied Tune Title.</td><td> 	wrapped in HTML, displayed in     webview
											</td></tr><tr>
					<td> JPEG		</td><td> As received with supplied Tune Title.	</td><td> wrapped in HTML, displayed in     webview
												</td></tr><tr>
					<td> GIF		</td><td> As received with supplied Tune Title.	</td><td> wrapped in HTML, displayed in     webview
													</td></tr><tr>
					<td> STL		</td><td> A new setlist is created.		</td><td> displays in standard Viewer frame
														</td></tr><tr>
					<td> ZIP		</td><td> Full Unzipped Tree Is Stored into a new archive. </td><td> Only top level directory is indexed by Tune Title.
														</td>	</tr>
					</table>



Useful Links
--------------------

I get 10 times more traffic from [Google] [1] than from
[Yahoo] [2] or [MSN] [3].

  [1]: http://google.com/        "Google"
  [2]: http://search.yahoo.com/  "Yahoo Search"
  [3]: http://search.msn.com/    "MSN Search"
