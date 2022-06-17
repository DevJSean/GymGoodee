package com.goodee.gym.batch;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.goodee.gym.util.MyFileUtils;


@Component  
public class DeleteIllegalFiles {
	
/*
	@Autowired
	private GalleryMapper galleryMapper;
	
	// 매일 새벽 3시에 어제 첨부된 파일 중 잘못된 파일들을 찾아서 제거한다.
	@Scheduled(cron = "0 0 3 * * *")  
	public void execute() throws Exception {
		
		// 어제 경로를 알아내기
		String yesterdayPath = MyFileUtils.getYesterdayPath();
		
		// DB에서 가져온 어제 저장된 첨부 파일 목록
		List<FileAttachDTO> fileAttaches = galleryMapper.selectFileAttachListAtYesterday();
		
		// DB에서 가져온 어제 저장된 첨부 파일들을 Path 객체(경로 + 파일명)로 List에 저장
		List<Path> yeaterdayPathes = fileAttaches.stream()
				.map(fileAttach -> Paths.get(yesterdayPath, fileAttach.getSaved()))
				.collect(Collectors.toList());
		
		// 함께 저장된 썸네일을 Path 객체를 가진 List에 추가 저장
		fileAttaches.stream()
		.map(fileAttach -> Paths.get(yesterdayPath, "s_" + fileAttach.getSaved()))
		.forEach(path -> yeaterdayPathes.add(path));
		
		// 어제 경로 디렉터리에 실제로 저장된 파일들과
		// DB에서 가져온 어제 저장된 첨부 파일 내역을 비교해서 일치하지 않는 파일을 제거
		File dir = new File(yesterdayPath);
		if(dir.exists()) {
			// 어제 경로 디렉터리에 실제로 저장된 파일들 중에서
			// DB에서 가져온 내역과 다른 파일들만 files에 저장(지워야 할 파일들)
			File[] files = dir.listFiles(file -> yeaterdayPathes.contains(file.toPath()) == false);
			for(File removeFile : files) {
				removeFile.delete();
			}
		}
		
	}
*/
}
