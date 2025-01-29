FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
COPY . App/
WORKDIR /App
EXPOSE 8090
ENTRYPOINT ["dotnet", "Demo.NET.Web.dll"]