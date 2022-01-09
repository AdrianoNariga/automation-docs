#!/usr/bin/python3
import sys
import os
from pytube import YouTube

link=sys.argv[1]
yt = YouTube(link)
path = os.getcwd()

print("Titulo: ", yt.title)
print("Views: ", yt.views)
print("Tempo: ", yt.length, "segundos")
print("Avaliacao", yt.rating)

ys = yt.streams.get_highest_resolution()

print("Baixando...")
ys.download(path)
print("Download completo!")
