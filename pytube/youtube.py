from pytube import YouTube

link = input("Video link: ")
path = input("Path para download: ")
yt = YouTube(link)

print("Titulo: ", yt.title)
print("Views: ", yt.views)
print("Tempo: ", yt.length, "segundos")
print("Avaliacao", yt.rating)

ys = yt.streams.get_highest_resolution()

print("Baixando...")
ys.download(path)
print("Download completo!")
